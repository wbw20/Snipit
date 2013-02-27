var coffeecup = require('coffeecup');
var express = require('express');
var dao = require('./dao');
var models = require('./models');

var app = express();
app.engine('coffee', require('coffeecup').__express);
app.use(express.static(__dirname + '/static'));

app.get('/', function(req, res) {
  res.render(__dirname + '/views/index.coffee');
});

app.get('/new', function(req, res) {
  var will = models.User.build({
    name: 'Will Wettersten',
    id: 'dsdgfddsfds'
  }).save();

  res.render(__dirname + '/views/new.coffee');
});

app.listen(8080);
