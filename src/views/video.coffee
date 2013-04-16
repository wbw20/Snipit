doctype 5
html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    link rel: 'stylesheet', type: 'text/css', href: 'flowplayer/skin/minimalist.css'
    script src: 'dojo/dojo.js'
    script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'
    script src: 'flowplayer/flowplayer.min.js'

  body class: 'claro', ->
    div class: 'bar', ->
      div class: 'loginBox', ->
        div class: 'loginDropdown', id: 'signinBox'
        div class: 'loginDropdown', id: 'signupBox'
      coffeescript ->
        require ['dojo/ready', 'dojo/on', 'dojo/parser', 'dijit/form/TextBox', 'dijit/form/Button', 'dijit/form/DropDownButton', 'dijit/TooltipDialog'], (ready, dojon, parser, TextBox, Button, DropDownButton, Dialog) ->
          ready () ->
            signinDialog = new Dialog {
              content: '<form id="signinform">' +
                         '<label for="username">userame:</label> <input type="text" data-dojo-type="dijit/form/TextBox" id="username" name="username"><br><br>' +
                         '<label for="password">password:</label> <input type="text" data-dojo-type="dijit/form/TextBox" id="password" name="password">' +
                         '<button id="signinsubmit" type="submit" data-dojo-type="dijit/form/Button">Save</button>' +
                       '</form>'
              onOpen: () ->
                dojo.connect (dojo.byId 'signinform'), "onsubmit", (event) ->
                  dojo.stopEvent event
                  dojo.xhrPost {
                    url: 'login',
                    form: (dojo.byId 'signinform'),
                    handleAs: 'application/json',
                    load: (data) ->
                      if data['status'] = 401
                        console.log 'FAIL',
                    error: (error) ->
                      console.log error
                  }
            }

            button = new DropDownButton {
              label: 'Sign In'
              dropDown: signinDialog
            }

            (dojo.byId 'signinBox').appendChild button.domNode

    h1 'Video Name: ' + ' Video ID: ' + @vid
    div id: 'video', ->
	  div class: 'flowplayer', 'data-swf': 'flowplayer/flowplayer.swf', 'data-ratio': '0.667', ->
	    video ->
	      source type: 'video/mp4', src: 'http://stream.flowplayer.org/bauhaus/624x260.mp4'   
	      #source type: 'video/mp4', src: 'test.flv'
	      
	      
	      
      
