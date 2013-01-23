var fs = require('fs');
var dao = require('./dao');

dao.connect()

var http = require('http').createServer(function handler(req, res) {
  fs.readFile(__dirname + '/views/index.html', function(err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    } else {
      res.writeHead(200);
      res.end(data);
    }
  });
}).listen(8080);
