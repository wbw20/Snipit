html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div id: 'nav', ->
      a href: '/', ->
        img id: 'nav-logo', src: 'logo-small.png'
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
                             '<label for="username">username:</label>' + 
                             '<input type="text" data-dojo-type="dijit/form/TextBox" id="username" name="username"><br><br>' +
                             '<label for="password">password:</label>' + 
                             '<input type="text" data-dojo-type="dijit/form/TextBox" id="password" name="password">' +
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
              require ['dojo/ready', 
                       'dijit/TooltipDialog', 
                       'dijit/popup', 
                       'dojo/on', 
                       'dojo/dom'], (ready, TooltipDialog, popup, dojon, dom) ->
                ready () ->
                  iconDialog = new TooltipDialog {
                    id: 'iconDialog',
                    style: 'width: 130px;',
                    content: '<button id="profile" type="button" data-dojo-type="dijit/form/Button"' + 
                                'onclick="window.location=\'/profile\'">view profile</button>' +
                              '<form action="logout">' +
                                '<button id="logoutsubmit" type="submit" data-dojo-type="dijit/form/Button">log out</button>' +
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
        div id: 'searchContainer', style: 'margin-bottom: 10px; margin-top: 20px'
        div id: 'placeHolder', style: 'width: 740px; height: 480px; background-color: #D4E7F3; margin-left: auto; margin-right: auto'
        div id: 'videoContainer', ->
          coffeescript ->
            require ['dojo/ready', 'dojo/dom-style', 'dijit/form/TextBox'], (ready, domstyle,  TextBox) ->
              ready () ->
                dojo.addOnLoad () ->
                  searchBox = new TextBox {
                    placeHolder: 'Enter a YouTube URL...'
                  }

                  (dojo.byId 'searchContainer').appendChild searchBox.domNode
                  domstyle.set searchBox.domNode, 'width', '30em'

                  dojo.connect searchBox, 'onChange', () ->
                    #Remove any videos that might exsist
                    dojo.destroy 'videoEmbed'

                    #Hide the placeholder
                    dojo.style (dojo.byId 'placeHolder'), 'display', 'none'

                    if (searchBox.value.indexOf 'youtube') == -1
                      # Hide placeholder
                      dojo.style (dojo.byId 'placeHolder'), 'display', ''
                    else
                      # Embed video
                      index = (searchBox.value.match ".com/").index + 5
                      embedUrl = (searchBox.value.slice 0, index) + 'embed/' + (searchBox.value.slice index + 8)
                      dojo.place (dojo.create 'iframe', {
                        id: 'videoEmbed',
                        src: embedUrl,
                        width: '740',
                        height: '480',
                        frameborder: '0',
                        'allowfullscreen'
                      }), (dojo.byId 'videoContainer')

                      (dojo.byId 'url').value = searchBox.value


        form method: 'post', style: 'margin: auto', ->
          table style: 'margin: auto;', ->
            tr ->
              td ->
                input id: 'url', name: 'url', style: 'display: none'
            tr ->
              td ->
                div id: 'startContainer', style: 'padding-right: 250px; padding-top: 3px'
              td ->
                div id: 'endContainer', style: 'padding-top: 3px'
            tr ->
              td colspan: '2', ->
                div id: 'nameContainer', style: 'padding-top: 3px'
            tr ->
              td colspan: '2', ->
                div id: 'tagContainer', style: 'display: inline-block; padding-top: 3px'
                div id: 'submitContainer', style: 'display: inline-block;', ->

          coffeescript ->
            require ['dijit/form/TextBox',
                     'dijit/form/Textarea',
                     'dijit/form/Button',
                     'dojo/dom-style'],
            (TextBox, TextArea, Button, domstyle) ->
              (dojo.byId 'startContainer').appendChild (new TextBox {
                name: 'start',
                placeHolder: 'Start (seconds)'
              }).domNode
              (dojo.byId 'endContainer').appendChild (new TextBox {
                name: 'end',
                placeHolder: 'End (seconds)'
              }).domNode

              nameBox = new TextBox {
                name: 'name',
                placeHolder: 'Name this snip'
              }
              (dojo.byId 'nameContainer').appendChild nameBox.domNode
              domstyle.set nameBox.domNode, 'width', '740px'
              domstyle.set nameBox.domNode, 'font-size', '32pt'

              tagBox = new TextArea {
                name: 'tag',
                value: '#Snipit #Video ...'
              }
              (dojo.byId 'tagContainer').appendChild tagBox.domNode
              domstyle.set tagBox.domNode, 'width', '680px'
              domstyle.set tagBox.domNode, 'height', '100px'
              domstyle.set tagBox.domNode, 'font-size', '12pt'

              (dojo.byId 'submitContainer').appendChild (new Button {
                type: 'Submit',
                label: 'Snip!'
              }).domNode
              
    div id: 'footer', ->
      p 'Created by Matt Prosser, Caley Shem-Crumrine, William Wettersten, and Greg Ziegan.'
      p ->
        text 'View our project report '
        a href: 'Prosser.Shem-Crumrine.Wettersten.Ziegan.FinalReport.pdf', ->
          text 'here'
        text '.'
