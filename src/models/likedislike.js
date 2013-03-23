var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = LikeDislike = connection.define('likedislike', {
        id          : { type: Sequalize.STRING, primaryKey: true },
        likedislike : { type: Sequalize.STRING, allowNull: false },
});
