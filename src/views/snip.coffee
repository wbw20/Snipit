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
                  content: '<form id="signinform" method="post" action="/login">' +
                             '<label for="username">userame:</label> <input type="text" data-dojo-type="dijit/form/TextBox" id="username" name="username"><br><br>' +
                             '<label for="password">password:</label> <input type="text" data-dojo-type="dijit/form/TextBox" id="password" name="password">' +
                             '<button id="signinsubmit" type="submit" data-dojo-type="dijit/form/Button">Login</button>' +
                           '</form>'
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
        li ->
          div id: 'snip'

          coffeescript ->
            require ['dojo/ready', 'dojo/on', 'dojo/parser', 'dijit/form/TextBox', 'dijit/form/Button'], (ready, dojon, parser, TextBox, Button) ->
              ready () ->

              snip_button = new Button {
                label: 'Snip a Video'
                onClick: () ->
                  window.location = '/snip';
              }

              (dojo.byId 'snip').appendChild snip_button.domNode 
        
    div id: 'container', ->
      div id: 'main', ->
        div id: 'searchContainer', style: 'margin-bottom: 20px'
        div id: 'placeHolder', style: 'width: 740px; height: 480px; background-color: #D4E7F3; margin-left: auto; margin-right: auto'
        div id: 'videoContainer', ->
          coffeescript ->
            require ['dojo/ready', 'dojo/dom-style', 'dijit/form/TextBox'], (ready, domstyle,  TextBox) ->
              ready () ->
                dojo.addOnLoad () ->
                  searchBox = new TextBox {
                    placeHolder: 'Enter a YouTube URL...'
                  }
                  domstyle.set searchBox.domNode, 'width', '30em'
                  (dojo.byId 'searchContainer').appendChild searchBox.domNode
                  dojo.connect searchBox, 'onChange', () ->
                    # Hide placeholder
                    dojo.style (dojo.byId 'placeHolder'), 'display', 'none'

                    # Embed video
                    index = (searchBox.value.match ".com/").index + 5
                    embedUrl = (searchBox.value.slice 0, index) + 'embed/' + (searchBox.value.slice index + 8)
                    dojo.place (dojo.create 'iframe', {
                      'src': embedUrl,
                      'width': '740',
                      'height': '480',
                      'frameborder': '0',
                      'allowfullscreen'
                    }), (dojo.byId 'videoContainer')

                    (dojo.byId 'url').value = searchBox.value

        form method: 'post', style: 'margin: auto', ->
          table style: 'margin: auto;', ->
            tr ->
              td ->
                #label for: 'start', ->
                  #'Start (ms)'
                #input name: 'start', style: 'margin-right: 100px'
                div id: 'start', style: 'padding-right: 250px'
              td ->
                #label for: 'end', ->
                  #'End (ms)'
                #input name: 'end'
                #input name: 'url', id: 'url', style: 'display: none'
                div id: 'end'
              coffeescript ->
                require ['dijit/form/TextBox'], (TextBox) ->
                  (dojo.byId 'start').appendChild (new TextBox {
                    placeHolder: 'Start (seconds)'
                  }).domNode
                  (dojo.byId 'end').appendChild (new TextBox {
                    placeHolder: 'End (seconds)'
                  }).domNode
            tr ->
              td ->
                label for: 'name', ->
                  'Name this snip! '
                input name: 'name', style: 'padding-right: 20px'
              td ->
                input type: 'submit', style: 'margin-left: auto; margin-right: auto;'
