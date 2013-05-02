var coffeecup = require('coffeecup');
var express = require('express');
var fs = require('fs');
var keygrip = require('keygrip')();
var Cookies = require('cookies');
var dao = require('./dao');
var util = require('./util');
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
  app.use(express.static(__dirname + '/../data'));
  app.use(express.bodyParser());
});

app.get('/', function(req, res) {
  res.render(__dirname + '/views/index.coffee', {
    user: req.user,
    videos: [{
      name: 'Popular',
      content: util.getPopular()
    }]
  });
});

app.get('/profile', function(req, res) {
  res.render(__dirname + '/views/profile.coffee', {
    user: req.user
  });
});

app.get('/uploads', function(req, res) {
  var ajaxdata = [];

  models.Video.findAll({
    where: {
      uploader: req.user.id
    }
  }).success(function(results) {
    console.log(results);
    for (var item in results) {
      console.log(item);
      ajaxdata.push({
        name: results[item].selectedValues.name,
        thumbnail: 'FAKE',
        description: 'description of ' + results[item].selectedValues.name
      });
    }
  });

  res.send(ajaxdata);
});

app.get('/snip', function(req, res) {
  res.render(__dirname + '/views/snip.coffee', {
    user: req.user,
  });
});

app.post('/snip', function(req, res) {
  util.spawn('java', ['-jar', '../opt/converter.jar', '../data/videos/delta.mpg', 3000000, 6000000]);
  res.render(__dirname + '/views/snip.coffee', {
    user: req.user,
  });
});

app.get('/new', function(req, res) {
  var will = models.User.build({
    name: 'Will Wettersten',
    username: 'wbw20',
    password: 'kitchin'
  }).save();

  res.render(__dirname + '/views/new.coffee');
});

app.post('/new', function (req, res) {
    models.User.build({
        first: req.body.first,
        last:req.body.last,
        username: req.body.username,
        password: req.body.password,
        email: req.body.email
    }).save()
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
        res.send('invalid login');
        res.send(401);//or don't
      }
    });
});

app.get('/logout', function (req, res) {
    var cookies = new Cookies(req, res, keygrip);
    cookies.set('login', 'wbw20', {
      overwrite: true,
      expires: new Date()
    });

    return res.redirect('/');
});

app.get('/user', function (req, res) {
    console.log (req.query);
    models.User.find({
        where: {
            username: req.query['username']
        }
    }).success(function(theUserWeFound) {
        if(theUserWeFound){
            res.send('taken');
        } else {
            res.send(200);
        }
    });
});

app.listen(8080);
