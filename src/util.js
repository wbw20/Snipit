var child = require('child_process');
var fs = require('fs');
var dao = require('./dao');
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
    models.Video.findAll({order: 'createdAt DESC', limit: 4
      }).success(function(video) {
        callback(video);
    }); 
  },

  /* grab 4 most popular videos */
  getPopular: function(callback) {
    models.Video.findAll({limit: 4
      }).success(function(video) {
        callback(video);
    });
  },

  /* search for videos by a list of keywords */
  search: function(terms, callback) {
    queryString = 'select videoId as id, name, path, uploader from' +
                  '  (select videoId from' +
                  '    (select videoId, count(*) from' +
                  '      tags T, tag_to_videoes TTV' +
                  "      where T.word = 'Snipit' ";

    JSON.parse(terms).forEach(function(term) {
      if (term.match(/^[a-zA-Z]+$/)) {
        queryString +=   'or T.word = ' + "'" + term + "'" + ' ';
      }
    });

    queryString += '   group by videoId) Z' +
                   ' limit 10) X,' +
                   ' videos Y' +
                   ' where X.videoId = Y.id';

    dao.connection.query(queryString).success(function(results) {
      callback(results);
    });
  }
}
