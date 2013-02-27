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
        require ['dijit/DropDownMenu', 'dijit/form/TextBox', 'dijit/form/DropDownButton'],
        (DropDownMenu, TextBox, DropDownButton) ->
          signinmenu = new DropDownMenu { style: "display: none;"}
          username = new TextBox
          signinmenu.addChild username

          password = new TextBox
          signinmenu.addChild password

          button = new DropDownButton {
              label: "Sign In",
              name: "signInButton",
              dropDown: signinmenu,
              id: "progButton"
          }
          dojo.byId('signupBox').appendChild button.domNode

          signupmenu = new DropDownMenu { style: "display: none;"}
          username = new TextBox
          signupmenu.addChild username

          password = new TextBox
          signupmenu.addChild password

          button = new DropDownButton {
              label: "Sign Up",
              name: "signUpButton",
              dropDown: signupmenu,
              id: "signUpButton"
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
