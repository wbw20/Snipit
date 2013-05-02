var child = require('child_process');
var fs = require('fs');
var models = require('./models');

module.exports = {
  spawn: function(process, args, onData, onEnd) {
    return child.spawn(process, args);
  },
  uuid: function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });
  },
  
  /* grab 4 videos with most views */
  getPopular: function(callback) {
    var toReturn = new Array();
      
    // look at video views table, count by video, display 4 with highest count
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
  }
}
