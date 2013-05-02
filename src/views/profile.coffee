html ->
  head ->
    title @username + '\'s Profile'
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'spacer', style: 'height: 50px'
    div style: 'width: 100%; overflow: hidden', ->
      div style: 'width: 60%; float: left', ->
        h1 @username
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
              console.log uploadata

              store = new ItemFileWriteStore { data: uploadata }

              layout = [[ {'name': 'Name', 'field': 'name', 'width': '100px'},
                          {'name': 'Thumbnail', 'field': 'thumbnail', 'width': '200px'},
                          {'name': 'Description', 'field': 'description', 'width': '100px'} ]]
              grid = new DataGrid {
                id: 'grid',
                store: store,
                structure: layout,
                rowSelector: '20px'
              }

              grid.placeAt 'contentTable'
              grid.startup ''
          }
     
      ###     
      table ->
        for video in @uploads 
          tr -> 
            td -> 
              a ->
                video.selectedValues.name
            #td -> a video.selectedValues.thumbnail
            #td -> a video.selectedValues.description
            td -> 
              a -> 
                video.selectedValues.createdAt.toString ''
            td -> 
              a -> 
                video.selectedValues.updatedAt.toString ''
      ###
                                
    div name: 'tabContainer', style: 'width: 60%', ->
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
