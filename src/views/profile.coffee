html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'spacer', style: 'height: 50px'
    div style: 'width: 100%; overflow: hidden', ->
      div style: 'width: 60%; float: left', ->
        h1 @user.username
      div name: 'avatarBox', style: 'float: left', ->
        img src: 'silhouette.png'
    div id: 'contentTable', ->
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
              div style: 'font-size: 40px; font-style: bold', ->
                video.selectedValues.name.toString()
              div style: 'position: relative; left: 40px', ->
                'upload-time: ' + video.selectedValues.createdAt.toString()
              div style: 'position: relative; left: 40px', ->
                'uploader: ' + video.selectedValues.uploader.toString()
              div ->
                'likes/dislikes' #TODO access from database
              div ->
                'Description...' #TODO put in database

    div name: 'tabContainer', style: 'width: 60%; margin: 0 auto', ->
      div id: 'tcl-prog'
      coffeescript ->
        require ["dojo/ready", "dijit/layout/TabContainer", "dijit/layout/ContentPane"], (ready, TabContainer, ContentPane) ->
          ready () ->
            tc = new TabContainer {
              style: 'height: 100%; width: 100%;'
            }, 'tcl-prog'

            cp1 = new ContentPane {
              title: 'uploads',
              content: dojo.byId 'contentTable'
            }
            tc.addChild cp1
 
            cp2 = new ContentPane {
              title: 'videos',
              content: 'put videos here'
            }
            tc.addChild cp2

            tc.startup ''
