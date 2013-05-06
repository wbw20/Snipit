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
  // asynchronous function to grab recently viewed videos
  util.getPopular(function(popular) {
    util.getRecent(function(recent) {
      res.render(__dirname + '/views/index.coffee', {
        user: req.user,
        videos: [{
          name: 'Popular',
          content: popular
        }, {
          name: 'Recent',
          content: recent
        }]
      });
    });
  });
});

app.get('/profile', function(req, res) {

  var url_str = url.parse(req.url, true).query;

  if (url_str.u == undefined) {
   res.send(404)
   return
  }

  models.User.find({where: {id: url_str.u}
  }).success(function(userForPage) {

    if (userForPage) {

      new Sequelize.Utils.QueryChainer()
        .add(dao.connection.query(util.getPlaylists(userForPage)))
        .add(dao.connection.query(util.getUploads(userForPage)))
        .add(dao.connection.query(util.getFavorites(userForPage)))
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
      } else
       res.send(404)
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

app.get('/search', function(req, res) {
  console.log(url.parse(req.url, true).query.terms);

  util.search(url.parse(req.url, true).query.terms, function(results) {
      res.send(results);
  })
});

app.get('/snip', function(req, res) {
  res.render(__dirname + '/views/snip.coffee', {
    user: req.user
  });
});

app.post('/snip', function(req, res) {
  var id = util.uuid();
  var converter;
  var downloader;

  //put new video in db
  models.Video.build({
    name: req.body.name,
    path: 'videos/snipped/' + id + '.flv',
    uploader: req.user.id
  }).save().success(function(video) {
    //put tags in the database
    var tags = req.body.tag.match(/(?!#)[0-9a-zA-Z]*/g);
    tags.forEach (function(word) {
      if (word) {
        models.Tag.findOrCreate({
          'word': word
        }).success(function(tag) {
          if (tag) {
            dao.connection.query('insert into tag_to_videoes (tagId, videoId, updatedAt, createdAt)' +
                                 '  values (' + tag.id + ', ' + video.id + ', now(), now());');
          }
        });
      }
    });
    res.redirect('/video?v=' + video.id);
  });

  downloader = util.spawn('java', ['-jar', '../opt/downloader.jar', req.body.url, '../data/videos/raw/' + id + '.mp4']);
    downloader.on('close', function(code) {
        converter = util.spawn('java', ['-jar', '../opt/converter.jar', '../data/videos/raw/' + id + '.mp4', req.body.start, req.body.end, '../data/videos/snipped/' + id + '.flv']);
        converter.stdout.on('data', function (data) {});
        converter.stderr.on('data', function (data) {});
        converter.on('close', function(code) {
            converter.kill();
            downloader.kill();
        });
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
      if (video) {
        // get comments
        models.Comment.findAll({
          where : { video: video.id },
          include: [models.User]
        }).success(function(comments) {
          //Has the snipping operation finished yet?
          fs.exists('../data/' + video.path, function(exists) {
            video.ready = exists;

            res.render(__dirname + '/views/video.coffee', {
              user: req.user,
              vid: video,
              uploader: video.user,
              comments: comments
            });
          })
        });
      // Video doesn't exist
      } else {
        res.send(404);
      }
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
      //authenticate the user
      if (theUserWeFound) {
        new Cookies(req, res, keygrip).set('login', req.body.username, {signed: true});
          return res.redirect('/');
      //or don't
      } else {
        res.send('invalid login');
        res.send(401);
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
