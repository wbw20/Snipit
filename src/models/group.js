var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = Group = connection.define('group', {
        id        : { type: Sequalize.STRING, allowNull: false },
        name      : { type: Sequalize.STRING, allowNull: false },
//        creator   : { type: Sequalize.STRING, allowNull: false },
});
