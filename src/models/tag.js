var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = Tag = connection.define('tag', {
        id        : { type: Sequalize.STRING, allowNull: false },
        word      : { type: Sequalize.STRING, allowNull: false }
});
