html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'main', class: 'main', ->
      div name: 'spacer', style: 'height: 50px'
      form method: 'post', ->
        table ->
          tr ->
            td ->
              label for: 'name', ->
                'Name'
              input name: 'name'

          tr ->
            td ->
              label for: 'age', ->
                'Age'
              input name: 'age'

          tr ->
            td ->
              label for: 'username', ->
                'Username'
              input name: 'username'

          tr ->
            td ->
              label for: 'password', ->
                'Password'
              input name: 'password'

        p ->
          input type: 'submit', style: 'float: left', value: 'Create'
