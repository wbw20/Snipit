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
              label for: 'url', ->
                'Youtube url'
              input name: 'url'

          tr ->
            td ->
              label for: 'start', ->
                'Start (ms)'
              input name: 'start'

          tr ->
            td ->
              label for: 'end', ->
                'End (ms)'
              input name: 'end'
        p ->
          input type: 'submit', style: 'float: left'
