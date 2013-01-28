var fs = require('fs'),
    persist = require('persist');

module.exports = {
    save : function(model) {
 
        persist.runSql('SELECT * FROM user');

        var connection = persist.connect({
              driver: 'mysql',
              database: 'snipit',
              password: 'wetw179#',
              debug: true
            }, function(err, conn){
                if(err) { next(err); return; }
                console.log(conn)
                model.save(conn, function() {
                console.log('save successful');
            });
        });
    }
}
