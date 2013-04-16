var fs = require('fs'),
    Sequelize = require('sequelize');

module.exports = {
  connection: (function(credentials) {
      return new Sequelize('snipit', credentials.db.username, credentials.db.password, {
        host: credentials.db.host,
        port: credentials.db.password
      })
    }(JSON.parse(fs.readFileSync('../conf/properties.json').toString()))
  ),

  createForeignKeys: function(models) {

  }
}
