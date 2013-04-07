html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'spacer', style: 'height: 50px'
    div style: 'width: 100%; overflow: hidden', ->
      div style: 'width: 60%; float: left', ->
        h1 @user.username
      div name: 'avatarBox', style: 'float: left', ->
        img src: 'silhouette.png'
      
