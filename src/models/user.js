var persist = require('persist');
var type = persist.type;

module.exports = User = persist.define('User', {
        'id'        : { type: type.STRING },
        'name'      : { type: type.STRING },
        'age'       : { type: type.INTEGER },
        'photo'     : { type: type.BLOB }// BLOB/BINARY
});

User.onSave = function(obj, connection, callback) {
  console.log('SAVING!');
}
