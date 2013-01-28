var coffeecup = require('coffeecup');
var express = require('express');

var app = express();
app.engine('coffee', require('coffeecup').__express);

var models = require('./models')
var dao = require('./dao')

var will = models.User();
will.name = 'Will';
will.id = 'dsfdsfds';
dao.save(will);

app.get('/', function(req, res) {
  res.render(__dirname + '/views/index.coffee');
});

app.listen(8080);
