doctype 5
html ->
  head ->
    title @vname + ' - SnipIt'
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    link rel: 'stylesheet', type: 'text/css', href: 'flowplayer/skin/minimalist.css'
    script src: 'dojo/dojo.js'
    script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'
    script src: 'flowplayer/flowplayer.min.js'

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
        h1 @vname
        div id: 'video', ->
	        div class: 'flowplayer', 'data-swf': 'flowplayer/flowplayer.swf', 'data-ratio': '0.667', ->
	          video ->
	            source type: 'video/webm', src: 'videos/' + @vid + '.webm'
	      div id: 'video-stats', class: 'clearfix', ->
	        span id: 'creator', ->
	          text 'Created by '
	          a href: 'profile?u=' + @uploader.id, ->
	            @uploader.username
	        span id: 'dislike'
	        span id: 'like'
	        coffeescript ->
            require ['dojo/ready', 'dojo/on', 'dojo/parser', 'dijit/form/TextBox', 'dijit/form/Button', 'dijit/form/DropDownButton', 'dijit/TooltipDialog'], (ready, dojon, parser, TextBox, Button, DropDownButton, Dialog) ->
                ready () ->
                
                like_button = new Button {
                  label: 'Like'
                }
                
                dislike_button = new Button {
                  label: 'Dislike'
                }

<<<<<<< HEAD
    h1 'Video Name: ' + ' Video ID: ' + @vid
    div id: 'video', ->
	  div class: 'flowplayer', 'data-swf': 'flowplayer/flowplayer.swf', 'data-ratio': '0.667', ->
	    video ->
	      source type: 'video/webm', src: 'test.webm'
	      
=======
                (dojo.byId 'like').appendChild like_button.domNode
                (dojo.byId 'dislike').appendChild dislike_button.domNode

            
	      h2 'Comments'
	      div id: 'comment-container', class: 'contentbar', ->
	        for i in @comments
	          div id: 'comment' + i.id, ->
	            a href: 'profile?u='+ i.user.id, ->
	              i.user.username
	            p i.comment
>>>>>>> dff055b73f6beddbef2a96ae9c6f0bda446434f0
	      
	      
      
