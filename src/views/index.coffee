html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
      div class: 'loginBox', ->
        div 'data-dojo-type': 'dijit/form/DropDownButton', ->
          div id: 'signinBox'
          div id: 'signupBox'
        div id: 'signupDropdown', class: 'hidden loginDropdown'
      coffeescript ->
        require ['dijit/DropDownMenu', 'dijit/form/TextBox', 'dijit/form/DropDownButton'],
        (DropDownMenu, TextBox, DropDownButton) ->
          menu = new DropDownMenu { style: "display: none;"}
          username = new TextBox
          menu.addChild username

          password = new TextBox
          menu.addChild password

          button = new DropDownButton {
              label: "Sign In",
              name: "signInButton",
              dropDown: menu,
              id: "progButton"
          }
          dojo.byId('signinBox').appendChild button.domNode

    div name: 'spacer', style: 'height: 50px'
    img src: 'logo.jpg'
    div class: 'block', id: 'searchContainer', ->
      coffeescript ->
        require ['dojo/ready', 'dijit/form/TextBox'], (ready, TextBox) ->
          ready () ->
            dojo.addOnLoad () ->
              searchBox = new TextBox
              (dojo.byId 'searchContainer').appendChild searchBox.domNode
