var coffeecup = require('coffeecup');
var express = require('express');
var dao = require('./dao');
var models = require('./models');

var app = express();
app.engine('coffee', require('coffeecup').__express);

//dao.init();
models.User.sync().success(function() {
var will = models.User.build({
  name: 'Tom',
  id: 'dsdgfddsfds'
}).save();
});

app.get('/', function(req, res) {
  res.render(__dirname + '/views/index.coffee');
});

app.listen(8080);
