html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div id: 'nav', ->
      ul ->
        unless @user
          li ->
            div id: 'register'
          li ->
            div class: 'loginDropdown', id: 'signinBox'

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

                login_button = new DropDownButton {
                  label: 'Sign In'
                  dropDown: signinDialog
                }
                
                register_button = new Button {
                  label: 'Register'
                  onClick: () ->
                    window.location = '/new';
                }

                (dojo.byId 'signinBox').appendChild login_button.domNode
                (dojo.byId 'register').appendChild register_button.domNode


        # still within loginBox
        if @user
          li ->
            span ->
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

    div id: 'container', ->
      div id: 'main', ->
        h1 ->
          img src: 'logo.png', alt: 'SnipIt video clip sharing'
        
        section name: 'search', ->
          div class: 'block', id: 'searchContainer', ->
            coffeescript ->
              require ['dojo/ready', 'dojo/dom-style', 'dijit/form/TextBox'], (ready, domstyle,  TextBox) ->
                ready () ->
                  dojo.addOnLoad () ->
                    dojoConfig = {
                      baseUrl: 'localhost:8080'
                    }

                    searchBox = new TextBox
                    (dojo.byId 'searchContainer').appendChild searchBox.domNode
        sections = [{
                      name: 'Popular'
                    }, {
                      name: 'Recent'
                    }, {
                      name: 'Our Favorites'
                    }]
        for sec in @videos
          section name: sec.name, ->
            div class: 'videocontainer', ->
              span class: 'videobartitle', ->
                sec.name
              div class: 'videobar', ->
                for thumbnail in sec.content
                  img src: 'photos/thumbnail/' + thumbnail.id + '.jpg', class: 'thumbnail', alt: 'play.png'

