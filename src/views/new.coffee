html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'main', class: 'main', style:'text-align: center', ->
      div name: 'spacer', style: 'height: 50px'
      img src: 'join.png'
      form method: 'post', ->
        table style: 'margin: auto', ->
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
              div id: 'email'

          tr ->
            td ->
              div id: 'confirmemail'

      div id: 'submitcontainer'

      coffeescript ->
        require ['dojo/ready', 'dojo/dom-style', 'dijit/form/TextBox', 'dijit/form/Button', 'dijit/form/ValidationTextBox', 'dijit/Tooltip', 'dojox/validate/web'], (ready, domstyle,  TextBox, Button, ValidationTextBox, Tooltip) ->
          ready () ->
            username = new ValidationTextBox {
              id: 'username',
              placeHolder: 'Username',
              takenMessage: new Tooltip {
                label: 'fuck you',
                connectId: 'username'
              }
              validator: () ->
                data = dojo.xhrGet {
                  url: '/user?username=' + username.value,
                  handleAs: 'text'
                }

                data.then (dojo.hitch this, (response) ->
                  console.log response

                  if response == 'taken'
                    this.displayMessage()
                )

                return false if data == 'taken'
                return true
            }

            (dojo.byId 'username').appendChild username.domNode
            domstyle.set username.domNode, 'width', '20.35em'

            first = new TextBox {
            placeHolder: 'First Name'
            }
            (dojo.byId 'first').appendChild first.domNode
            domstyle.set first.domNode, 'width', '10em'

            last = new TextBox {
            placeHolder: 'Last Name'
            }
            (dojo.byId 'last').appendChild last.domNode
            domstyle.set last.domNode, 'width', '10em'

            password = new ValidationTextBox {
            placeHolder: 'Password'
            validator: () ->
              return password.value.length>=8 && password.value.length<=18
            invalidMessage: "Must be between 8 and 18 characters"
            }
            (dojo.byId 'password').appendChild password.domNode
            domstyle.set password.domNode, 'width', '20.35em'

            email = new ValidationTextBox {
            placeHolder: 'Email Address'
            validator: dojox.validate.isEmailAddress
            invalidMessage: 'Invalid email address'
            }
            (dojo.byId 'email').appendChild email.domNode
            domstyle.set email.domNode, 'width', '20.35em'

            confirmemail = new ValidationTextBox {
            placeHolder: 'Confirm Email Address'
            validator: () ->
              return email.value==confirmemail.value
            invalidMessage: 'Does not match'
            }
            (dojo.byId 'confirmemail').appendChild confirmemail.domNode
            domstyle.set confirmemail.domNode, 'width', '20.35em'

            submit = new Button {
              label: 'Join'
            }
            (dojo.byId 'submitcontainer').appendChild submit.domNode