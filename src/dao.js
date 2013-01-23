var fs = require('fs'),
    xml2js = require('xml2js'),
    mysql = require('mysql');

var parser = new xml2js.Parser();

module.exports = {
  connect : function() {

    fs.readFile(__dirname + '/../conf/properties.xml', function(err, data) {
      parser.parseString(data, function(err, result) {
        var password = result.db.password[0]
      });
    });
  }
}
