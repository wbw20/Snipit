html ->
  head ->
    title @pageUser.username + '\'s Profile'
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div id: 'nav', ->
      a href: '/', ->
        img id: 'nav-logo', src: 'logo-small.png'
      ul -> # List containing navigation menu
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

        if @user
          li ->
            span ->
              'hello, ' + @user.name
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
      h1 id: 'profile-header', ->
        @pageUser.username
      img id: 'user-icon', src: 'silhouette.png'
      div id: 'infoBox', ->
        table style: 'font-size: 20px', ->
          tr ->
            td ->
              div name: 'fullName', ->
                p @pageUser.name
          tr ->
            td ->
              div name: 'age', ->
                if (@pageUser.age == null)
                  p 'Age not given'
                else
                  p @pageUser.age
          tr ->
            td ->
              div name: 'joinDate', ->
                p 'Joined on ' + @pageUser.createdAt.toString().slice(0,15)

      if @user

	      div id: 'message-box', ->
	        form method: 'post', action: 'message', ->
	          input name: 'recipient', type: 'hidden', value: @pageUser.id
	          div id: 'message-text'
	          div id: 'submit-message'
	          coffeescript ->
              require ['dojo/ready',
                       'dojo/dom-style',
                       'dijit/form/Textarea',
                       'dijit/form/Button'], (ready, domstyle, TextArea, Button) ->
                ready () ->
                  messageBox = new TextArea {
                    name: 'message',
                    value: 'Message this user...',
                    style: 'width:400px;height:100px;'
                  }
                  (dojo.byId 'message-text').appendChild messageBox.domNode

	                (dojo.byId 'submit-message').appendChild (new Button {
                    type: 'Submit',
                    label: 'Submit',
                    style: 'margin-top:5px;'
                  }).domNode

      # Videos the user has uploaded
      div id: 'uploadedVids', ->
        table class: 'profileTable', ->
          for video in @uploads
            tr class: 'profileRow', ->
              td ->
                a href: '/video?v=' + video.id, ->
                  img src: 'photos/thumbnail/' + (video.path.match '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}') + '.png', class: 'thumbnailLarge'
              td class: 'profileColDesc', ->
                div class: 'title', ->
                  video.name.toString()
                div style: 'position: relative; left: 40px', ->
                 'Created on ' + video.createdAt.toString().slice(0,15)
                div ->
                  'Description...' #TODO put in database

      # Videos the user has favorited
      div id: 'favoriteVids', ->
        table class: 'profileTable', ->
          for video in @favorites
            tr class: 'profileRow', ->
              td ->
                a href: '/video?v=' + video.id, ->
                  img src: 'photos/thumbnail/' + (video.path.match '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}') + '.png', class: 'thumbnailLarge'
              td class: 'profileColDesc', ->
                div class: 'title', ->
                  video.name
                div style: 'position: relative; left: 40px', ->
                  'Created on ' + video.createdAt.toString().slice(0,15)
                div style: 'position: relative; left: 40px', ->
                  if video.userId
                    a href: '/profile?u=' + video.userId, ->
                      text 'Uploaded by ' + video.username
                  else
                    text 'Uploaded Anonymously'
                div ->
                  'Description...'

      # Playlists the user has made
      div id: 'playlists', ->
        table class: 'profileTable', ->
          for playlist in @playlists
            tr class: 'profileRow', ->
              td style: 'padding: 20px', ->
                a href: '/video?v=' + video.id, ->
                  img src: 'photos/thumbnail/' + (video.path.match '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}') + '.png', class: 'thumbnailSmall'
                  div ->
                    img src: 'photos/thumbnail/' + (video.path.match '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}') + '.png', class: 'thumbnailTiny'
                    img src: 'photos/thumbnail/' + (video.path.match '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}') + '.png', class: 'thumbnailTiny'
              td class: 'profileColDesc', ->
                div class: 'title', -> # Displays playlist's title
                  playlist.name.toString()
                div ->
                  playlist.numVideos.toString() + ' videos in playlist'
                div style: 'position: relative; left: 40px', -> # Displays playlist creation date
                  'Created on ' + playlist.createdAt.toString().slice(0,15)


      # Messages to the user
      div id: 'messages', ->

        # display messages
        for message in @messages
          a href: 'profile?u='+ message.user.id, ->
            message.user.username
          p message.message



      div id: 'tabContainer', ->
        div id: 'tcl-prog'
        coffeescript ->
          require ["dojo/ready", "dijit/layout/TabContainer", "dijit/layout/ContentPane"], (ready, TabContainer, ContentPane) ->
            ready () ->
              tc = new TabContainer {
                style: 'height: 100%; width: 100%;'
              }, 'tcl-prog'

              cp1 = new ContentPane {
                title: 'Uploads',
                content: dojo.byId 'uploadedVids'
              }
              tc.addChild cp1

              cp2 = new ContentPane {
                title: 'Favorites',
                content: dojo.byId 'favoriteVids'
              }
              tc.addChild cp2

              cp3 = new ContentPane {
                title: 'Playlists',
                content: dojo.byId 'playlists'
              }
              tc.addChild cp3

              cp3 = new ContentPane {
                title: 'Messages',
                content: dojo.byId 'messages'
              }
              tc.addChild cp3

              tc.startup ''

    div id: 'footer', ->
      p 'Created by Matt Prosser, Caley Shem-Crumrine, William Wettersten, and Greg Ziegan.'
      p ->
        text 'View our project report '
        a href: 'Prosser.Shem-Crumrine.Wettersten.Ziegan.FinalReport.pdf', ->
          text 'here'
        text '.'
