var coffeecup = require('coffeecup');
var express = require('express');
var crypto = require('crypto');
var fs = require('fs');
var ursa = require('ursa');
var Cookies = require('cookies');
var dao = require('./dao');
var models = require('./models');

/* BEGIN MAIN ROUTINE */

var app = express();
dao.createForeignKeys(models);
dao.connection.sync().failure(function(error) {
  console.log(error);
});

/* rsa keys */
var password = JSON.parse(fs.readFileSync('../conf/properties.json').toString()).keys.password;
var key = ursa.createPrivateKey(fs.readFileSync('../conf/id_rsa.pem', 'utf8'), password); 

app.configure(function() {

  /* our state of the art authentication filter */
  app.use(function(req, res, next) {
    var cookie = new Cookies(req, res).get('login');
    console.log('COOKIE: ' + cookie);

    if (cookie) {
      key.decrypt(cookie);
    }

    next();
  });

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
        console.log('USER: ' + theUserWeFound.username + ' ' + theUserWeFound.password);
        var cookieHash = key.encrypt(
          new Buffer(theUserWeFound.username + theUserWeFound.password, 'utf8'));
        new Cookies(req, res).set('login', cookieHash);
        res.send(200); //authenticate the user
      } else {
        res.send(401); //fuck 'em
      }
    });
});

app.listen(8080);
