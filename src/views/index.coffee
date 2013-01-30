html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    script src: 'dojo/dojo.js'

  body ->
    img src: 'logo.jpg'
    div class: 'block', 'data-dojo-id': 'search', 'data-dojo-type': 'dijit/form/Form', encType: 'multipart/form-data', action: '', method: '', ->
      input type: 'text', name: 'search', id: 'search', 'data-dojo-type': 'dijit/form/ValidationTextBox', required: 'true'
      coffeescript ->
        require ["dojo/parser", "dijit/form/Form", "dijit/form/Button", "dijit/form/ValidationTextBox", "dijit/form/DateTextBox"]
      coffeescript ->
        require 'dojo/ready', (ready) ->
          ready () ->
            alert 'yay'
