var fs = require('fs'),
    xml2js = require('xml2js');

var parser = new xml2js.Parser();
parser.addListener('end', function(result) {
    console.dir(result);
    console.log('Done.');
});

module.exports = {
  getCredentials : function() {
    console.log(__dirname + '/../conf/properties.xml')
    fs.readFile(__dirname + '/../conf/properties.xml', function(err, data) {
      parser.parseString(data);
    });
  }
}
