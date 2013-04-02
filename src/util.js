var child = require('child_process')

module.exports = {
  spawn: function(process, args, options) {
    return child.spawn(process, args, options);
  }
}
