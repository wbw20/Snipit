html ->
  head ->
    title 'Welcome to SnipIt'
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
              require ['dojo/ready',
                       'dojo/on',
                       'dojo/parser',
                       'dijit/form/TextBox',
                       'dijit/form/Button',
                       'dijit/form/DropDownButton',
                       'dijit/TooltipDialog'],
              (ready, dojon, parser, TextBox, Button, DropDownButton, Dialog) ->
                ready () ->
                signinDialog = new Dialog {
                  content: '<form id="signinform" method="post" action="/login">' +
                             '<label for="username">username:</label>' + 
                             '<input type="text" data-dojo-type="dijit/form/TextBox" id="username" name="username"><br><br>' +
                             '<label for="password">password:</label>' + 
                             '<input type="password" data-dojo-type="dijit/form/TextBox" id="password" name="password">' +
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
                  dojo.connect searchBox, 'onChange', () ->
                    console.log (searchBox.value.split ' ')
                    dojo.xhrGet {
                      url: '/search?terms=' + JSON.stringify(searchBox.value.split ' '),
                      handleAs: 'text',
                      handle: (data) ->
                        dojo.destroy 'resultGrid'

                        domstyle.set (dojo.byId 'resultsTitle'), 'display', ''
                        container = dojo.create 'div', {
                          id: 'resultGrid',
                          style: {
                            'background-color': '#DBDBDB',
                            border: '2px solid #B8CCFF',
                            margin: '0 auto',
                            height: (Math.ceil((JSON.parse data).length/4))*167,
                            width: '827px'
                          }
                        }, (dojo.byId 'resultsContainer')

                        for result in (JSON.parse data)
                          link = dojo.create 'a', {
                            href: 'video?v=' + result.id
                          }, container

                          thumbnail = dojo.create 'img', {
                            style: {
                              float: 'left',
                              height: '135px',
                              width: '187',
                              padding: '15px 0 15px 15px'
                            },
                            src: 'photos/thumbnail/' + (result.path.match '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}') + '.png',
                            alt: result.name
                          }, link
                    }
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
      h2 id: 'resultsTitle', style: 'display: none', ->
        'Results'
      div id: 'resultsContainer'
      for sec in @videos
        section name: sec.name, ->
          div class: 'videocontainer', ->
            h2 ->
              sec.name
            div class: 'contentbar clearfix', ->
              for vid in sec.content
                a href: 'video?v=' + vid.id, ->
                  imgPath = 'photos/thumbnail/' + (vid.path.match '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}') + '.png'
                  img src: imgPath, class: 'thumbnail', alt: vid.name
    
    div id: 'footer', ->
      p 'Created by Matt Prosser, Caley Shem-Crumrine, William Wettersten, and Greg Ziegan.'
      p ->
        text 'View our project report '
        a href: 'Prosser.Shem-Crumrine.Wettersten.Ziegan.FinalReport.pdf', ->
          text 'here'
        text '.'
    
    
    
    
