html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'main', style: 'text-align: center;', class: 'main', ->
      div name: 'spacer', style: 'height: 50px'
      div id: 'searchContainer'
      div id: 'videoContainer', ->
        coffeescript ->
          require ['dojo/ready', 'dojo/dom-style', 'dijit/form/TextBox'], (ready, domstyle,  TextBox) ->
            ready () ->
              dojo.addOnLoad () ->
                searchBox = new TextBox
                domstyle.set searchBox.domNode, 'width', '30em'
                (dojo.byId 'searchContainer').appendChild searchBox.domNode
                dojo.connect searchBox, 'onChange', () ->
                  index = (searchBox.value.match ".com/").index + 5
                  embedUrl = (searchBox.value.slice 0, index) + 'embed/' + (searchBox.value.slice index + 8)
                  dojo.place (dojo.create 'iframe', {
                    'src': embedUrl,
                    'width': '560',
                    'height': '315',
                    'frameborder': '0',
                    'allowfullscreen'
                  }), (dojo.byId 'videoContainer')

      form method: 'post', style: 'margin: auto', ->
        table style: 'margin: auto;', ->
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
        input type: 'submit', style: 'margin-left: auto; margin-right: auto;'
