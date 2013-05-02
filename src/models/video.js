var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = Video = connection.define('video', {
        id        : { type: Sequalize.STRING, primaryKey: true },
        name      : { type: Sequalize.STRING, allowNull: false },
});
