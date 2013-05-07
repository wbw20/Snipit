doctype 5
html ->
  head ->
    title @vid.name + ' - SnipIt'
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'
    script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'
    script src: 'flowplayer/flowplayer-3.2.12.min.js'

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
        h1 @vid.name
        if @vid.ready
          div id: 'video', ->
            a href: @vid.path, id: 'flowplayer', ->
            coffeescript ->
              flowplayer 'flowplayer', 'flowplayer/flowplayer-3.2.16.swf'        
        else
          h1 'NOT READY'
	      div id: 'video-stats', class: 'clearfix', ->
	        span id: 'creator', ->
            if @uploader
              text 'Created by '
              a href: 'profile?u=' + @uploader.id, ->
                @uploader.username
            else
              text 'Created Anonymously'
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

                (dojo.byId 'like').appendChild like_button.domNode
                (dojo.byId 'dislike').appendChild dislike_button.domNode

      h2 'Comments'
      div id: 'comment-container', class: 'contentbar', ->
        for i in @comments
          div id: 'comment' + i.id, ->
            a href: 'profile?u='+ i.user.id, ->
              i.user.username
            p i.comment
            
        # TODO: only if user is logged in!
	      h2 'Add a Comment'  
	      div id: 'add-comment', class: 'contentbar', ->
	        form method: 'post', ->
	          input name: 'vid_id', type: 'hidden', value: @vid.id
	          div id: 'comment-box'
	          div id: 'submit-comment'
	          coffeescript ->
              require ['dojo/ready', 
                       'dojo/dom-style', 
                       'dijit/form/Textarea', 
                       'dijit/form/Button'], (ready, domstyle, TextArea, Button) ->
                ready () ->
                  commentBox = new TextArea {
                    name: 'comment',
                    style: 'width:400px;height:100px;'
                  }
                  (dojo.byId 'comment-box').appendChild commentBox.domNode
	          
	                (dojo.byId 'submit-comment').appendChild (new Button {
                    type: 'Submit',
                    label: 'Submit',
                    style: 'margin-top:5px;'
                  }).domNode
	          
	          
	          
	          
	          
	          
      
