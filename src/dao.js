var fs = require('fs'),
    xml2js = require('xml2js'),
    persist = require('persist');

var parser = new xml2js.Parser();

module.exports = {
    save : function(model) {
        var connection = persist.connect(function(err, conn){
            console.log(conn)
            model.save(conn, function() {
                console.log('save successful');
            });
        });
    }
}
