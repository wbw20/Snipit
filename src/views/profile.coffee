html ->
  head ->
    title @pageUser.username + '\'s Profile'
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div id: 'nav', ->
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

        if @user
          li ->
            span ->
              'hello, ' + @user.name
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

    div name: 'spacer', style: 'height: 100px'
    div style: 'width: 100%; overflow: hidden', ->
      div style: 'width: 60%; float: left', ->
        h1 @pageUser.username
      div name: 'avatarBox', style: 'width: 60%; float: left', ->
        img src: 'silhouette.png'
      div name: 'infoBox', style: 'position: relative; bottom: -140px; left: -150px', ->
        table style: 'font-size: 35px', ->
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
                p 'Joined On ' + @pageUser.createdAt.toString().slice(0,15)
          tr ->
            td ->
              div name: 'aboutMe', ->
                'About Me: ......'

    # Videos the user has uploaded
    div id: 'uploadedVids', ->
      table class: 'profileTable', ->
        for video in @uploads
          console.log video
          tr class: 'profileRow', ->
            td ->
              a ->
                filename = 'photos/thumbnail/' + video.path.slice(15, -8) + '.png'
                img src: filename, class: 'thumbnailLarge'
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
              a ->
                img src: 'photos/thumbnail/' + video.path.slice(15,-8) + '.png', class: 'thumbnailLarge'
            td class: 'profileColDesc', ->
              div class: 'title', ->
                video.videoName.toString()
              div style: 'position: relative; left: 40px', ->
                'Created on ' + video.vidCreatedAt.toString().slice(0,15)
              div style: 'position: relative; left: 40px', ->
                'Uploaded by ' + video.uploaderName
              div ->
                video.likeCount.toString() + ' likes'
              div ->
                'Description...'

    # Playlists the user has made
    div id: 'playlists', ->
      table class: 'profileTable', ->
        for playlist in @playlists
          tr class: 'profileRow', ->
            td style: 'padding: 20px', ->
                img src: 'photos/thumbnail/' + playlist.path1.slice(15, -8) + '.png', class: 'thumbnailSmall'
                div ->
                  img src: 'photos/thumbnail/' + playlist.path2.slice(15, -8) + '.png', class: 'thumbnailTiny'
                  img src: 'photos/thumbnail/' + playlist.path3.slice(15, -8) + '.png', class: 'thumbnailTiny'
            td class: 'profileColDesc', ->
              div class: 'title', -> # Displays playlist's title
                playlist.name.toString()
              div ->
                playlist.numVideos.toString() + ' videos in playlist'
              div style: 'position: relative; left: 40px', -> # Displays playlist creation date
                'Created on ' + playlist.createdAt.toString().slice(0,15)

    div name: 'tabContainer', style: 'width: 60%; margin: 0 auto', ->
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

            tc.startup ''
