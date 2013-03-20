var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = User = connection.define('user', {
        id        : { type: Sequalize.STRING, allowNull: false },
        name      : { type: Sequalize.STRING, allowNull: false },
        username  : { type: Sequalize.STRING, allowNull: false },
        password  : { type: Sequalize.STRING, allowNull: false },
        age       : { type: Sequalize.INTEGER }
});
