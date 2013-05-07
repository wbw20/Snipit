html ->
  head ->
    title: 'Join SnipIt!'
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
        div name: 'spacer', style: 'height: 50px'
        img src: 'join.png'
        form id: 'newuserform', method: 'post', ->
          table style: 'margin:0 auto;', ->
            tr ->
              td ->
                div id: 'first', style: 'display: inline-block; margin-right: 4px'
                div id: 'last', style: 'display: inline-block'

            tr ->
              td ->
                div id: 'username'

            tr ->
              td ->
                div id: 'password'

            tr ->
              td ->
                div id: 'confirmPassword'

            tr ->
              td ->
                div id: 'email'

            tr ->
              td ->
                div id: 'confirmEmail'
          div id: 'enabledContainer', style: 'display: none'
          div id: 'disabledContainer'

        coffeescript ->
          require ['dojo/ready', 'dojo/dom-style', 'dijit/form/TextBox', 'dijit/form/Button', 'dijit/form/ValidationTextBox', 'dijit/Tooltip', 'dojox/validate/web'], (ready, domstyle,  TextBox, Button, ValidationTextBox, Tooltip) ->
            ready () ->
              username = new ValidationTextBox {
                name: 'username'
                placeHolder: 'Username',
                invalidMessage: 'Taken',
                validator: () ->
                  data = dojo.xhrGet {
                    url: '/user?username=' + username.value,
                    handleAs: 'text'
                  }

                  data.then (dojo.hitch this, (response) ->
                    if response == 'taken'
                      this.set('state', 'error')
                      this.displayMessage("Username Taken")
                  )
                  return true
              }

              (dojo.byId 'username').appendChild username.domNode
              domstyle.set username.domNode, 'width', '20.35em'

              first = new TextBox {
                name: 'first',
              placeHolder: 'First Name'
              }
              (dojo.byId 'first').appendChild first.domNode
              domstyle.set first.domNode, 'width', '10em'

              last = new TextBox {
                name: 'last',
              placeHolder: 'Last Name'
              }
              (dojo.byId 'last').appendChild last.domNode
              domstyle.set last.domNode, 'width', '10em'

              password = new ValidationTextBox {
                name: 'password',
                type: 'password',
                placeHolder: 'Password',
                validator: () ->
                  return password.value == '' || password.value.length>=8 && password.value.length<=18
                invalidMessage: "Must be between 8 and 18 characters"
              }
              (dojo.byId 'password').appendChild password.domNode
              domstyle.set password.domNode, 'width', '20.35em'

              confirmPassword = new ValidationTextBox {
              name: 'confirmPassword',
              type: 'password',
              placeHolder: 'Confirm Password',
              validator: () ->
                return password.value == '' || password.value == confirmPassword.value
              invalidMessage: "Passwords must match"
              }
              (dojo.byId 'confirmPassword').appendChild confirmPassword.domNode
              domstyle.set confirmPassword.domNode, 'width', '20.35em'

              email = new ValidationTextBox {
              name: 'email',
              placeHolder: 'Email Address'
              validator: dojox.validate.isEmailAddress
              invalidMessage: 'Invalid email address'
              }
              (dojo.byId 'email').appendChild email.domNode
              domstyle.set email.domNode, 'width', '20.35em'

              confirmEmail = new ValidationTextBox {
              placeHolder: 'Confirm Email Address'
              validator: () ->
                return email.value==confirmEmail.value
              invalidMessage: 'Emails must match'
              }
              (dojo.byId 'confirmEmail').appendChild confirmEmail.domNode
              domstyle.set confirmEmail.domNode, 'width', '20.35em'

              submitEnabled = new Button {
                id: 'submitEnabled',
                disabled: false,
                label: 'Join',
                type: 'Submit'
              }

              submitDisabled = new Button {
                id: 'submitDisabled',
                disabled: true,
                label: 'Join',
                type: 'Submit'
                }

              checkForm = () ->
                if password.isValid() && confirmPassword.isValid() && email.isValid() && confirmEmail.isValid() && username.isValid() && password.value
                  dojo.style 'enabledContainer', 'display', ''
                  dojo.style 'disabledContainer', 'display', 'none'
                else
                  dojo.style 'enabledContainer', 'display', 'none'
                  dojo.style 'disabledContainer', 'display', ''


              dojo.connect username, 'onChange', checkForm
              dojo.connect password, 'onChange', checkForm
              dojo.connect confirmPassword, 'onChange', checkForm
              dojo.connect email, 'onChange', checkForm
              dojo.connect confirmEmail, 'onChange', checkForm

              (dojo.byId 'enabledContainer').appendChild submitEnabled.domNode
              (dojo.byId 'disabledContainer').appendChild submitDisabled.domNode
