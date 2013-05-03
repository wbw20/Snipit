html ->
  head ->
    title @username + '\'s Profile'
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'spacer', style: 'height: 100px'
    div style: 'width: 100%; overflow: hidden', ->
      div style: 'width: 60%; float: left', ->
        h1 @user.username
      div name: 'avatarBox', style: 'width: 60%; float: left', ->
        img src: 'silhouette.png'
      div name: 'infoBox', style: 'position: relative; bottom: -100px; left: -150px', ->
        table ->
          tr ->
            td ->
              div name: 'age', ->
                p @user.age
          tr ->
            td ->
              div name: 'joinDate', ->
                p 'Joined On ' + @user.createdAt.toString().slice(0,15)
          tr ->
            td ->
              div name: 'aboutMe', ->
                'About Me: ......'

    div id: 'uploadedVids', ->
      coffeescript ->
        require ['dojo/_base/lang', 'dojox/grid/DataGrid', 'dojo/data/ItemFileWriteStore',
        'dojo/dom', 'dojo/domReady!'], (lang, DataGrid, ItemFileWriteStore, dom) ->
          dojo.xhrGet {
            url: 'uploads',
            handleAs: 'text',
            load: (uploadata) ->
          }

      table class: 'profileTable', ->
        for video in @uploads
          tr class: 'profileRow', ->
            td ->
              a ->
                img src: 'Biff-300x208.jpg', class: 'thumbnailLarge'
            td class: 'profileColDesc', ->
              div class: 'title', ->
                video.selectedValues.title.toString()
              div style: 'position: relative; left: 40px', ->
                'Created on ' + video.selectedValues.createdAt.toString().slice(0,15)
              div ->
                'Likes | Dislikes' #TODO access from database
              div ->
                'Description...' #TODO put in database

    div id: 'favoriteVids', ->
      table class: 'profileTable', ->
        for video in @uploads #TODO use @favorites
          tr class: 'profileRow', ->
            td ->
              a ->
                img src: 'Biff-300x208.jpg', class: 'thumbnailLarge'
            td class: 'profileColDesc', ->
              div class: 'title', ->
                video.selectedValues.title.toString()
              div style: 'position: relative; left: 40px', ->
                'Created on ' + video.selectedValues.createdAt.toString()
              div style: 'position: relative; left: 40px', ->
                #'Uploaded by ' + video.selectedValues.
              div ->
                'Likes | Dislikes'
              div ->
                'Description...'

    div id: 'playlists', ->
      table class: 'profileTable', ->
        for playlist in @uploads # TODO make into @playlists
          tr class: 'profileRow', ->
            td style: 'padding: 20px', ->
                img src: 'Biff-300x208.jpg', class: 'thumbnailSmall'
                div ->
                  img src: 'testThumb.jpg', class: 'thumbnailTiny'
                  img src: 'testThumb2.jpg', class: 'thumbnailTiny'
            td class: 'profileColDesc', ->
              div class: 'title', -> # Displays playlist's title
                'Playlist Title Here' # + playlist.selectedValues.playlistTitle.toString()
              div ->
                'Num of Videos in Playlist Here' # + playlist.selectedValues.vidCount.toString()
              div style: 'position: relative; left: 40px', -> # Displays playlist creation date
                'Created on ' # + playlist.selectedValues.createdAt.toString()

    div name: 'tabContainer', style: 'width: 60%; margin: 0 auto', ->
      div id: 'tcl-prog'
      coffeescript ->
        require ["dojo/ready", "dijit/layout/TabContainer", "dijit/layout/ContentPane"], (ready, TabContainer, ContentPane) ->
          ready () ->
            tc = new TabContainer {
              style: 'height: 100%; width: 100%;'
            }, 'tcl-prog'

            cp1 = new ContentPane {
              title: 'Uploads',
              content: dojo.byId 'uploadedVids'
            }
            tc.addChild cp1

            cp2 = new ContentPane {
              title: 'Favorites',
              content: dojo.byId 'favoriteVids'
            }
            tc.addChild cp2

            cp3 = new ContentPane {
              title: 'Playlists',
              content: dojo.byId 'playlists'
            }
            tc.addChild cp3

            tc.startup ''
