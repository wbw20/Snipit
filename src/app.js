var coffeecup = require('coffeecup');
var express = require('express');

var app = express();
app.engine('coffee', require('coffeecup').__express);

app.get('/', function(req, res) {
  res.render(__dirname + '/views/index.coffee');
});

app.listen(8080);
