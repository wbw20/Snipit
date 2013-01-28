var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = User = connection.define('user', {
        id        : { type: Sequalize.STRING },
        name      : { type: Sequalize.STRING },
        age       : { type: Sequalize.INTEGER }
});
