var coffeecup = require('coffeecup');
var express = require('express');
var crypto = require('crypto');
var fs = require('fs');
var ursa = require('ursa');
var Cookies = require('cookies');
var dao = require('./dao');
var models = require('./models');

var app = express();
dao.connection.sync().failure(function(error) {
  console.log(error);
});

/* rsa keys */
var privateKey = fs.readFileSync('../conf/id_rsa', 'utf8'); 
//var publicKey = ursa.createPublicKey(fs.readFileSync('../conf/id_rsa.pub', 'utf8'));

console.log(privateKey);
//console.log(publicKey);

app.configure(function() {

  /* our state of the art authentication filter */
  app.use(function(req, res, next) {
    var cookie = new Cookies(req, res).get('login');
    console.log(cookie);

    if (cookie) {
      privateKey.decrypt(cookie, undefined, 'utf8');
    }

    next();
  });

  app.use(app.router);
  app.engine('coffee', require('coffeecup').__express);
  app.use(express.static(__dirname + '/static'));
  app.use(express.bodyParser());
});

app.get('/', function(req, res) {
  res.render(__dirname + '/views/index.coffee');
});

app.get('/new', function(req, res) {
  var will = models.User.build({
    name: 'Will Wettersten',
    username: 'wbw20',
    password: 'kitchin',
    id: 'dsdgfddsfds'
  }).save();

  res.render(__dirname + '/views/new.coffee');
});

app.post('/login', function (req, res) {
    models.User.find({
      where: {
        username: req.body.username,
        password: req.body.password
      }
    }).success(function(theUserWeFound) {
      if (theUserWeFound) {
        var cookieHash = publicKey.encrypt(
          new Buffer(theUserWeFound.username + theUserWeFound.password, 'utf8'));
        new Cookies(req, res).set('login', cookieHash);
        res.send(200); //authenticate the user
      } else {
        res.send(401); //fuck 'em
      }
    });
});

app.listen(8080);
