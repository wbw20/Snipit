var fs = require('fs'),
    Sequelize = require('sequelize');

module.exports = {
  connection: new Sequelize('snipit', 'root', 'wetw179#', {
    host: 'localhost',
    port: 3306
  })
}
