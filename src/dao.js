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
    var User = models.User;
    var Video = models.Video;
    var Tag = models.Tag;
    var Playlist = models.Playlist;
    var Group = models.Group;
    var Message = models.Message;
    var Comment = models.Comment;
    var LikeDislike = models.LikeDislike;

    /* Entity Foreign keys */
    Video.belongsTo(User);
    Playlist.belongsTo(User);
    Group.belongsTo(User);

    /* Playlist Member */
    Playlist.hasMany(Video, {joinTableName: 'video_to_playlist'});
    Video.hasMany(Playlist, {joinTableName: 'video_to_playlist'});

    /* Group Member */
    User.hasMany(Group, {joinTableName: 'user_to_group'});
    Group.hasMany(User, {joinTableName: 'user_to_group'});

    /* Video View */
    User.hasMany(Video, {joinTableName: 'user_to_video_view'});
    Video.hasMany(User, {joinTableName: 'user_to_video_view'});

    /* Video Favorite */
    User.hasMany(Video, {joinTableName: 'user_to_video_favorite'});
    Video.hasMany(User, {joinTableName: 'user_to_video_favorite'});

    /* Tags */
    Tag.hasMany(Video, {joinTableName: 'tag_to_video'});
    Video.hasMany(Tag, {joinTableName: 'tag_to_video'});

    /* Messages */
    Message.belongsTo(User, {foreignKey: 'sender'});
    Message.belongsTo(User, {foreignKey: 'recipient'});

    /* Comments */
    Comment.belongsTo(User);
    Comment.belongsTo(Video);

    /* Like/Dislike */
    LikeDislike.belongsTo(User);
    LikeDislike.belongsTo(Video);
  }
}
