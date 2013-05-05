var child = require('child_process');
var fs = require('fs');
var models = require('./models');

module.exports = {
  /* wrapper for build-in child.spawn */
  spawn: function(process, args, onData, onEnd) {
    return child.spawn(process, args);
  },

  /* generates Java-style UUIDs */
  uuid: function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });
  },

  /* grab 4 videos with most views */
  getPopular: function(callback) {

      /* fake data for now */
      var results = [{
                       name: "video 1",
                       id:   "Aabc50a0-a460-11e2-9e96-0800200c9a66",
                     }, {
                       name: "video 2",
                       id:   "Babc50a0-a460-11e2-9e96-0800200c9a66",
                     }, {
                       name: "video 3",
                       id:   "Cabc50a0-a460-11e2-9e96-0800200c9a66",
                     }, {
                       name: "video 4",
                       id:   "Dabc50a0-a460-11e2-9e96-0800200c9a66",
                     }];

      var toReturn = new Array();
      for (var i = 0; i < results.length; i++) {
        toReturn[i] = {
                        name:      results[i].name,
                        id:        results[i].id
                        //thumbnail: fs.readFileSync('../data/photos/thumbnail/' + results[i].id + '.jpg')
                      };
      }

    return toReturn;
  },

  /* grab 4 videos created most recently */
  getRecent: function(callback) {
    var toReturn = new Array();

    models.Video.findAll({order: 'createdAt DESC', limit: 4
      }).success(function(video) {

        for (var i = 0; i < 4; i++) {
          if (typeof(video[i]) != "undefined") {
            toReturn[i] = {
               name:      video[i].selectedValues.name,
               id:        video[i].selectedValues.id
               //thumbnail: fs.readFileSync('../data/photos/thumbnail/' + results[i].id + '.jpg')
            };
          }
        }

        callback(toReturn);
    });
  },

  getPlaylists: function(userForPage) {
    return('select P.id, P.name, P.createdAt, P.creator, PH1.path as path1, PH2.path as path2, ' +
           'PH3.path as path3, count(V.id) as numVideos from videos V, video_to_playlists VP, ' +
           'playlists P, (select V.path from videos V, video_to_playlists VP, playlists P ' +
           'where V.id = VP.videoId and VP.playlistId = P.id and P.creator = ' + userForPage.id + ' ' +
           'order by V.id limit 1) as PH1, (select V.path from videos V, video_to_playlists VP, ' +
           'playlists P where V.id = VP.videoId and VP.playlistId = P.id and ' +
           'P.creator = ' + userForPage.id + ' ' + 'order by V.id desc limit 1) as PH2, ' +
           '(select V.path from videos V, video_to_playlists VP, playlists P where V.id = VP.videoId ' +
           'and VP.playlistId = P.id and P.creator = ' + userForPage.id + '  order by V.id limit 2) ' +
           'as PH3 where VP.videoId = V.id and VP.playlistId = P.id and P.creator = ' + userForPage.id + ' ' +
           'and PH3.path <> PH1.path group by P.id')
  },

  getFavorites: function(userForPage) {

        return('select * from ' +
               '(select V.id as videoId, V.createdAt, U.id as userId, ' +
               'U.name, U.username, U.age, V.path, V.name as videoName, V.uploader as uploader '+
               'from user_to_video_favorites F, videos V, users U ' +
               'where F.videoId = V.id and F.userId = U.id and U.id = ' + userForPage.id
               + ') X, ' +
               '(select U.id, U.username as uploaderName ' +
               'from users U) Y ' +
               'where Y.id = X.uploader;')
  }
}

