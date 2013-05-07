var fs = require('fs'),
    Sequelize = require('sequelize');

module.exports = {
  connection: (function(credentials) {
      return new Sequelize('snipit', credentials.db.username, credentials.db.password, {
        host: credentials.db.host,
        port: credentials.db.port
      })
    }(JSON.parse(fs.readFileSync('../conf/properties.json').toString()))
  ),

  createForeignKeys: function(models) {

    /* Entity Foreign keys */
    Video.belongsTo(User, {foreignKey: 'uploader'});
    Playlist.belongsTo(User, {foreignKey: 'creator'});
    Group.belongsTo(User, {foreignKey: 'owner'});

    /* Playlist Member */
    Playlist.hasMany(Video, {joinTableName: 'video_to_playlist'});
    Video.hasMany(Playlist, {joinTableName: 'video_to_playlist'});

    /* Group Member */
    User.hasMany(Group, {joinTableName: 'user_to_group'});
    Group.hasMany(User, {joinTableName: 'user_to_group'});

    /* Video View */
    User.hasMany(Video, {joinTableName: 'user_to_video_views'});
    Video.hasMany(User, {joinTableName: 'user_to_video_views'});

    /* Video Favorite */
    User.hasMany(Video, {joinTableName: 'user_to_video_favorite'});
    Video.hasMany(User, {joinTableName: 'user_to_video_favorite'});

    /* Tags */
    Tag.hasMany(Video, {joinTableName: 'tag_to_video'});
    Video.hasMany(Tag, {joinTableName: 'tag_to_video'});

    /* Messages */
    Message.belongsTo(User, {foreignKey: 'recipient'});
    Message.belongsTo(User, {foreignKey: 'sender'});

    /* Comments */
    Comment.belongsTo(User, {foreignKey: 'user'});
    Comment.belongsTo(Video, {foreignKey: 'video'});

    /* Like/Dislike */
    LikeDislike.belongsTo(User, {foreignKey: 'user'});
    LikeDislike.belongsTo(Video, {foreignKey: 'video'});
  }
}
