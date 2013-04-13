html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
      div class: 'loginBox', ->
        unless @user
          div class: 'loginDropdown', id: 'signinBox'
          div class: 'loginDropdown', id: 'signupBox'
          coffeescript ->
            require ['dojo/ready', 'dojo/on', 'dojo/parser', 'dijit/form/TextBox', 'dijit/form/Button', 'dijit/form/DropDownButton', 'dijit/TooltipDialog'], (ready, dojon, parser, TextBox, Button, DropDownButton, Dialog) ->
              ready () ->
              signinDialog = new Dialog {
                content: '<form id="signinform">' +
                           '<label for="username">userame:</label> <input type="text" data-dojo-type="dijit/form/TextBox" id="username" name="username"><br><br>' +
                           '<label for="password">password:</label> <input type="text" data-dojo-type="dijit/form/TextBox" id="password" name="password">' +
                           '<button id="signinsubmit" type="submit" data-dojo-type="dijit/form/Button">Login</button>' +
                         '</form>'
                onOpen: () ->
                  dojo.connect (dojo.byId 'signinform'), "onsubmit", (event) ->
                    dojo.stopEvent event
                    dojo.xhrPost {
                      url: 'login',
                      form: (dojo.byId 'signinform'),
                      load: (data) ->
                        if data == 'invalid login'
                          console.log 'FAIL'
                        else
                          location.reload(true)
                      error: (error) ->
                        console.log error
                    }
              }

              button = new DropDownButton {
                label: 'Sign In'
                dropDown: signinDialog
              }

              (dojo.byId 'signinBox').appendChild button.domNode

        # still within loginBox
        if @user
          span style: 'vertical-align: top;', ->
            'hello, ' + @user.username
          img id: 'icon', src: 'icon.png'

          coffeescript ->
            require ['dojo/ready', 'dijit/TooltipDialog', 'dijit/popup', 'dojo/on', 'dojo/dom'], (ready, TooltipDialog, popup, dojon, dom) ->
              ready () ->
                iconDialog = new TooltipDialog {
                  id: 'iconDialog',
                  style: 'width: 300px;',
                  content: '<form action="logout">' +
                              '<button id="logoutsubmit" type="submit" data-dojo-type="dijit/form/Button">Log out</button>' +
                            '</form>',
                  onMouseLeave: () ->
                    popup.close iconDialog
                }

                dojon (dom.byId 'icon'), 'mouseover', () ->
                  popup.open {
                    popup: iconDialog,
                    around: (dom.byId 'icon')
                  }

    div id: 'main', class: 'main', ->
      section name: 'search', ->
        div name: 'spacer', style: 'height: 50px'
        img src: 'logo.jpg'
        div name: 'spacer', style: 'height: 20px'
        div class: 'block', id: 'searchContainer', ->
          coffeescript ->
            require ['dojo/ready', 'dojo/dom-style', 'dijit/form/TextBox'], (ready, domstyle,  TextBox) ->
              ready () ->
                dojo.addOnLoad () ->
                  dojoConfig = {
                    baseUrl: 'localhost:8080'
                  }

                  searchBox = new TextBox
                  domstyle.set searchBox.domNode, 'width', '30em'
                  (dojo.byId 'searchContainer').appendChild searchBox.domNode
      sections = [{
                    name: 'Popular'
                  }, {
                    name: 'Recent'
                  }, {
                    name: 'Our Favorites'
                  }]
      div name: 'spacer', style: 'height: 60px'
      for sec in @videos
        section name: sec.name, ->
          div name: 'spacer', style: 'height: 40px', ->
          div class: 'videocontainer', ->
            span class: 'videobartitle', ->
              sec.name
            div class: 'videobar', ->
              for thumbnail in sec.content
                img src: 'photos/thumbnail/' + thumbnail.id + '.jpg', class: 'thumbnail', alt: 'play.png'

      div name: 'footer', style: 'float: bottom', ->
        span 'copyright 2013 Snipit'
