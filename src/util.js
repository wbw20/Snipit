var child = require('child_process');
var fs = require('fs');

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
  getPopular: function() {
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
                   }, {
                     name: "video 5",
                     id:   "Eabc50a0-a460-11e2-9e96-0800200c9a66",
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
  }
}
