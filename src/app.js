var coffeecup = require('coffeecup');
var express = require('express');
var fs = require('fs');
var keygrip = require('keygrip')();
var Cookies = require('cookies');
var dao = require('./dao');
var models = require('./models');

/* BEGIN MAIN ROUTINE */

var app = express();
dao.createForeignKeys(models);
dao.connection.sync().failure(function(error) {
  console.log(error);
});

app.configure(function() {
  /* our state of the art authentication filter */
  app.use(function(req, res, next) {
    var cookie = new Cookies(req, res, keygrip).get('login', {signed: true});

    if (cookie) {
      models.User.find({
        where: {
          username: cookie.toString(),
        }
      }).success(function(foundUser) {
        req.user = foundUser;
        next();
      });
    } else {
      next();
    }
  });

  app.engine('coffee', require('coffeecup').__express);
  app.use(express.static(__dirname + '/static'));
  app.use(express.bodyParser());
});

app.get('/', function(req, res) {
  res.render(__dirname + '/views/index.coffee', {
    user: req.user
  });
});

app.get('/profile', function(req, res) {
  res.render(__dirname + '/views/profile.coffee', {
    user: req.user
  });
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
        new Cookies(req, res, keygrip).set('login', req.body.username, {signed: true});
        res.send(200); //authenticate the user
      } else {
        res.send(401); //fuck 'em
      }
    });
});

app.listen(8080);
