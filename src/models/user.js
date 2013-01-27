var persist = require('persist');

module.exports = persist.define('user', {
        id        : persist.type.STRING,
        name      : persist.type.STRING,
        age       : persist.type.INTEGER,
        photo     : persist.type.BLOB // BLOB/BINARY
});
