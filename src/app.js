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

/* app & cookie configuration */
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

/* main page */
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

/* user profile page */
app.get('/profile', function(req, res) {

  var url_str = url.parse(req.url, true).query;

  // if no user specified
  if (url_str.u == undefined) {
    // if user logged in, default to their profile
    if (req.user != undefined) {
      url_str.u = req.user.id
    
    // else 404
    } else {
     res.send(404)
     return
    }
  }    

  util.getMessages(url_str.u, function(messages) {
    models.User.find({where: {id: url_str.u}
        }).success(function(userForPage) {

      if (userForPage) {
        new Sequelize.Utils.QueryChainer()
          .add(dao.connection.query(util.getPlaylists(userForPage)))
          .run().success(function(results) {
            util.getUploads(userForPage, function(videos) {
              util.getFavorites(userForPage, function(favorites) {
                var playlistsForPage = results[0];
                var favoritesForPage = results[1];

                res.render(__dirname + '/views/profile.coffee', {
                    user: req.user,
                    pageUser: userForPage,
                    uploads: videos,
                    playlists: playlistsForPage,
                    favorites: favorites,
                    messages: messages
                });
              });
            });
          });
        } else {
         res.send(404)
        }
    });
  });
});

/*  */
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

/* seach box */
app.get('/search', function(req, res) {
  util.search(url.parse(req.url, true).query.terms, function(results) {
      res.send(results);
  })
});

/* snip video page */
app.get('/snip', function(req, res) {
  res.render(__dirname + '/views/snip.coffee', {
    user: req.user
  });
});

/* snips video! */
app.post('/snip', function(req, res) {
  var id = util.uuid();
  var converter;
  var downloader;

  //put new video in db
  models.Video.build({
    name: req.body.name,
    path: 'videos/snipped/' + id + '.flv',
    uploader: req.user ? req.user.id : 0
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
        converter = util.spawn('java', ['-jar', '../opt/converter.jar', '../data/videos/raw/' + id + '.mp4', req.body.start*1000000, req.body.end*1000000, '../data/videos/snipped/' + id + '.flv']);
        converter.stdout.on('data', function (data) {});
        converter.stderr.on('data', function (data) {});
        converter.on('close', function(code) {
            converter.kill();
            downloader.kill();
        });
    });
});

/* create new user page */
app.get('/new', function(req, res) {
  res.render(__dirname + '/views/new.coffee');
});

/* video page */
app.get('/video', function(req, res) {
  var url_str = url.parse(req.url, true).query;

  // Add a video view to the database
  util.addView(url_str.v, req.user.id, function(result) {
    // Get video
    models.Video.find({where : {id: url_str.v}, include: [models.User]
      }).success(function(video) {
          if (video) {
              // get comments
              models.Comment.findAll({
                  where : { video: video.id },
                  include: [models.User]
              }).success(function(comments) {
                      util.getVideoInfo(video.id, req.user ? req.user.id : 0, function(likesdislikesfavorites) {
                          //Has the snipping operation finished yet?
                          fs.exists('../data/' + video.path, function(exists) {
                              video.ready = exists;

                              res.render(__dirname + '/views/video.coffee', {
                                  user: req.user,
                                  vid: video,
                                  uploader: video.user,
                                  comments: comments,
                                  likesfavs: likesdislikesfavorites
                              });
                          });
                      })
                  });
            // Video doesn't exist
          } else {
              res.send(404);
          }
      });
  });
});

app.get('/info', function(req, res) {
  var url_str = url.parse(req.url, true).query;

  util.getVideoInfo(url_str.v, req.user.id, function (results) {
    res.send(results);
  });
});


/* saves video comments */
app.post('/comment', function (req, res) {
  models.Comment.build({
      comment: req.body.comment,
      user: req.user.id,
      video: req.body.vid_id
  }).save();

  res.redirect('/video?v=' + req.body.vid_id);
});

/* saves user messages */
app.post('/message', function (req, res) {
  models.Message.build({
      message: req.body.message,
      sender: req.user.id,
      recipient: req.body.recipient
  }).save();

  res.redirect('/profile?u=' + req.body.recipient);
});

/* saves new user */
app.post('/new', function (req, res) {
    models.User.build({
        name: req.body.first + ' ' + req.body.last,
        username: req.body.username,
        password: req.body.password,
        email: req.body.email
    }).save().success(function(user) {
      new Cookies(req, res, keygrip).set('login', req.body.username, {signed: true});
      req.user = user;
      res.redirect('/');
    });
});

app.post('/like', function(req, res) {
    models.LikeDislike.build({
        likedislike: 'like',
        user: req.user.id,
        video: req.body.video
    }).save();

    res.send(200);
});

app.post('/dislike', function(req, res) {
    models.LikeDislike.build({
        likedislike: 'dislike',
        user: req.user.id,
        video: req.body.video
    }).save();

    res.send(200);
});

app.post('/favorite', function(req, res) {
    dao.connection.query('insert into user_to_video_favorites' +
                         '  values (' + req.body.video + ', ' + req.user.id + ', now(), now());');

    res.send(200);
});

/* login form */
app.post('/login', function (req, res) {
    models.User.find({
      where: {
        username: req.body.username,
        password: req.body.password
      }
    }).success(function(theUserWeFound) {
      // authenticate the user
      if (theUserWeFound) {
        new Cookies(req, res, keygrip).set('login', req.body.username, {signed: true});
          return res.redirect('/');
      // if error
      } else {
        res.redirect("/oops?m=Invalid username or password. Please try again.");
      }
    }).error(function(error) {
      res.redirect("/oops?m=Invalid username or password. Please try again.");
    });
});

/* logs current user out */
app.get('/logout', function (req, res) {
    var cookies = new Cookies(req, res, keygrip);
    cookies.set('login', 'wbw20', {
      overwrite: true,
      expires: new Date()
    });

    return res.redirect('/');
});


/* used to check if username is taken */
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

/* 404/error page */
app.get('/oops', function (req, res) {
  var url_str = url.parse(req.url, true).query;
  
  res.render(__dirname + '/views/oops.coffee', {
    user: req.user,
    message: url_str.m
  });                                
});

/* 404 route (ALWAYS keep this as the last route) */
app.get('*', function(req, res){
  res.redirect("/oops?m=It looks like the page you're looking for doesn't exist.");
});

app.listen(8080);
