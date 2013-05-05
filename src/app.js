var coffeecup = require('coffeecup');
var express = require('express');
var fs = require('fs');
var keygrip = require('keygrip')();
var Cookies = require('cookies');
var Sequelize = require('sequelize');
var url = require('url');
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
  util.getRecent(function(recent) {
    res.render(__dirname + '/views/index.coffee', {
      user: req.user,
      videos: [{
        name: 'Popular',
        content: util.getPopular()
      }, {
        name: 'Recent',
        content: recent
      }]
    });
  });
});

app.get('/profile', function(req, res) {

  var url_str = url.parse(req.url, true).query;

  models.User.find({where: {id: url_str.u}
  }).success(function(userForPage) {

    new Sequelize.Utils.QueryChainer()
      .add(dao.connection.query('select P.id, P.name, P.createdAt, P.creator, ' +
                              'count(V.id) as numVideos from ' +
                              'videos V, playlists P, video_to_playlists VP ' +
                              'where VP.videoId = V.id and VP.playlistId = P.id and ' +
                              'P.creator = ' + userForPage.id + ' ' +
                              'group by P.id'))
      .add(models.Video.findAll({where: {uploader: userForPage.id}}))
      .add(dao.connection.query('select * from ' +
                              '(select V.id as videoId, V.createdAt, U.id as userId, U.name, U.username, ' +
                              'U.age, V.name as videoName, V.uploader as uploader ' +
                              'from user_to_video_favorites F, videos V, users U ' +
                              'where F.videoId = V.id and F.userId = U.id and U.id = '
                              + userForPage.id + ') X, ' +
                              '(select U.id, U.username as uploaderName ' +
                              'from users U) Y ' +
                              'where Y.id = X.uploader;'))
      .run()
      .success(function(results) {
        var playlistsForPage = results[0]
        var videos = results[1]
        var favoritesForPage = results[2]

      res.render(__dirname + '/views/profile.coffee', {
        user: req.user,
        pageUser: userForPage,
        uploads: videos,
        playlists: playlistsForPage,
        favorites: favoritesForPage
      });
    });
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
  var id = util.uuid();
  var converter;
  var downloader;

  // snip
  //var convert = function() {

  //}

  downloader = util.spawn('java', ['-jar', '../opt/downloader.jar', req.body.url, '../data/videos/raw/' + id + '.mp4']);
    downloader.on('close', function(code) {
      //put new video in db
      models.Video.build({
        name: req.body.name,
        file: '../data/videos/snipped/' + id + '.mpg'
      }).save();

        converter = util.spawn('java', ['-jar', '../opt/converter.jar', '../data/videos/raw/' + id + '.mp4', req.body.start, req.body.end, '../data/videos/snipped/' + id + '.mpg']);
        converter.stdout.on('data', function (data) {
            console.log(data.toString());
        });
        converter.stderr.on('data', function (data) {
        });
        converter.on('close', function(code) {
            console.log('OVER!');
            converter.kill();
            downloader.kill();
        });
    });

  res.render(__dirname + '/views/snip.coffee', {
    user: req.user
  });
});

app.get('/new', function(req, res) {
  res.render(__dirname + '/views/new.coffee');
});

app.get('/video', function(req, res) {
  var url_str = url.parse(req.url, true).query;

  // get video
  models.Video.find({where : {id: url_str.v}, include: [models.User]
    }).success(function(video) {
	    // get comments
      models.Comment.findAll({where : {video: video.id}, include: [models.User]
        }).success(function(comments) {
          res.render(__dirname + '/views/video.coffee', {
            user: req.user,
            vid: video.id,
            vname: video.name,
            uploader: video.user,
            comments: comments
          });
          console.log(video);
      });
  });
});

app.post('/new', function (req, res) {
    models.User.build({
        name: req.body.first + ' ' + req.body.last,
        username: req.body.username,
        password: req.body.password,
        email: req.body.email
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
