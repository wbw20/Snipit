html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
      div class: 'loginBox', ->
        div class: 'loginDropdown', id: 'signinBox'
        div class: 'loginDropdown', id: 'signupBox'
      coffeescript ->
        require ['dojo/ready', 'dojo/parser', 'dijit/form/TextBox', 'dijit/form/DropDownButton', 'dijit/TooltipDialog'], (ready, parser, TextBox, Button, Dialog) ->
          ready () ->
            signinDialog = new Dialog {
              content: '<label for="username">userame:</label> <input data-dojo-type="dijit/form/TextBox" id="username" name="username"><br><br>' +
                       '<label for="password">password:</label> <input data-dojo-type="dijit/form/TextBox" id="password" name="password">'
            }

            button = new Button {
              label: 'Sign In'
              dropDown: signinDialog
            }

            (dojo.byId 'signinBox').appendChild button.domNode

    div name: 'spacer', style: 'height: 50px'
    img src: 'logo.jpg'
    div class: 'block', id: 'searchContainer', ->
      coffeescript ->
        require ['dojo/ready', 'dijit/form/TextBox'], (ready, TextBox) ->
          ready () ->
            dojo.addOnLoad () ->
              searchBox = new TextBox
              (dojo.byId 'searchContainer').appendChild searchBox.domNode
