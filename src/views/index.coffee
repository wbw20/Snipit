html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
      div class: 'loginBox', ->
        span id: 'signin', 'Sign In  '
        span id: 'signup', '  Sign Up'
        div id: 'signinDropdown', class: 'hidden loginDropdown', ->
          input type: 'text', 'data-dojo-type': 'dijit/form/TextBox', 'data-dojo-props': 'trim:true, propercase:true', id: 'email'
        div id: 'signupDropdown', class: 'hidden loginDropdown'
      coffeescript ->
        signIn = dojo.byId 'signin'
        signUp = dojo.byId 'signup'

        dojo.connect signIn, 'onclick', (event) ->
          dojo.toggleClass 'signinDropdown', 'hidden'
        dojo.connect signUp, 'onclick', (event) ->
          dojo.toggleClass 'signupDropdown', 'hidden'

    div name: 'spacer', style: 'height: 50px'
    img src: 'logo.jpg'
    div class: 'block', id: 'searchContainer', ->
      coffeescript ->
        require ['dojo/ready', 'dijit/form/TextBox'], (ready) ->
          ready () ->
            dojo.addOnLoad () ->
              searchBox = new dijit.form.TextBox
              (dojo.byId 'searchContainer').appendChild searchBox.domNode
