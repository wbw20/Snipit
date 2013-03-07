var coffeecup = require('coffeecup');
var express = require('express');
var dao = require('./dao');
var models = require('./models');

var app = express();
dao.connection.sync().failure(function(error) {
  console.log(error);
});
app.engine('coffee', require('coffeecup').__express);
app.use(express.static(__dirname + '/static'));
app.use(express.bodyParser());

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
        res.send(200); //authenticate the user
      } else {
        res.send(401); //fuck 'em
      }
    });
});

function checkAuth(req, res, next) {
  if (!req.session.user_id) {
    res.send('You are not authorized to view this page');
  } else {
    next();
  }
}

app.listen(8080);
