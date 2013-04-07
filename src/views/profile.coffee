html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'spacer', style: 'height: 50px'
    div style: 'width: 60%', ->
      h1 @user.username
