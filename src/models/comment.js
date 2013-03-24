var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = Comment = connection.define('comment', {
        id        : { type: Sequalize.STRING, primaryKey: true },
        comment   : { type: Sequalize.STRING, allowNull: false },
});
