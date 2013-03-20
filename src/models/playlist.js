var Sequalize = require('sequelize');
var connection = require('../dao').connection;

module.exports = Playlist = connection.define('playlist', {
        id        : { type: Sequalize.STRING, allowNull: false },
        name      : { type: Sequalize.STRING, allowNull: false },
        creator   : { type: Sequalize.STRING, allowNull: false },
});
