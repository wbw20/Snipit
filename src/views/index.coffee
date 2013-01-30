html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    img src: 'logo.jpg'
    div class: 'block', id: 'searchContainer', ->
      coffeescript ->
        require ['dojo/ready', 'dijit/form/TextBox'], (ready) ->
          ready () ->
            dojo.addOnLoad () ->
              searchBox = new dijit.form.TextBox
              (dojo.byId 'searchContainer').appendChild searchBox.domNode
