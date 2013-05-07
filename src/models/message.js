var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = Message = connection.define('message', {
        id        : { type: Sequalize.STRING, primaryKey: true },
        message   : { type: Sequalize.STRING, allowNull: false },
});
