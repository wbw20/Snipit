html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
      div class: 'loginBox', ->
        div 'data-dojo-type': 'dijit/form/DropDownButton', ->
          span 'Sign In'
          div 'data-dojo-type': 'dijit/TooltopDialog', ->
            input 'data-dojo-type': 'dijit/form/TextBox'
            button 'data-dojo-type': 'dijit/form/Button', type: 'submit'
        span id: 'signup', '  Sign Up'
        div id: 'signupDropdown', class: 'hidden loginDropdown'
      coffeescript ->
        signUp = dojo.byId 'signup'

        dojo.connect signUp, 'onclick', (event) ->
          dojo.toggleClass 'signupDropdown', 'hidden'

    div name: 'spacer', style: 'height: 50px'
    img src: 'logo.jpg'
    div class: 'block', id: 'searchContainer', ->
      coffeescript ->
        require ['dojo/ready', 'dijit/form/TextBox', 'dijit/form/DropDownButton', 'dijit/TooltipDialog'], (ready) ->
          ready () ->
            dojo.addOnLoad () ->
              searchBox = new dijit.form.TextBox
              (dojo.byId 'searchContainer').appendChild searchBox.domNode
