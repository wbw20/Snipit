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
              content: 'put uploads here'
            }
            tc.addChild cp1
 
            cp2 = new ContentPane {
              title: 'videos',
              content: 'put videos here'
            }
            tc.addChild cp2

            tc.startup
