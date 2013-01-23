var fs = require('fs'),
    xml2js = require('xml2js'),
    mysql = require('mysql');

var parser = new xml2js.Parser();
var connection;

module.exports = {
  connect : function() {
    fs.readFile(__dirname + '/../conf/properties.xml', function(err, data) {
      parser.parseString(data, function(err, result) {
        connection = mysql.createConnection({
          user: result.db.username[0],
          password: result.db.password[0],
          database: 'snipit'
        });
      });

     connection.query('create table test (id varchar(32)) engine=innodb;')
    });
  }
}
