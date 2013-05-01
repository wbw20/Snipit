html ->
  head ->
    link rel: 'stylesheet', type: 'text/css', href: 'style.css'
    link rel: 'stylesheet', type: 'text/css', href: 'dijit/themes/claro/claro.css'
    script src: 'dojo/dojo.js'

  body class: 'claro', ->
    div class: 'bar', ->
    div name: 'main', style: 'text-align: center;', class: 'main', ->
      div name: 'spacer', style: 'height: 50px'
      div id: 'searchContainer', style: 'margin-bottom: 20px'
      div id: 'placeHolder', style: 'width: 740px; height: 480px; background-color: #D4E7F3; margin-left: auto; margin-right: auto'
      div id: 'videoContainer', ->
        coffeescript ->
          require ['dojo/ready', 'dojo/dom-style', 'dijit/form/TextBox'], (ready, domstyle,  TextBox) ->
            ready () ->
              dojo.addOnLoad () ->
                searchBox = new TextBox
                domstyle.set searchBox.domNode, 'width', '30em'
                (dojo.byId 'searchContainer').appendChild searchBox.domNode
                dojo.connect searchBox, 'onChange', () ->
                  # Hide placeholder
                  dojo.style (dojo.byId 'placeHolder'), 'display', 'none'

                  # Embed video
                  index = (searchBox.value.match ".com/").index + 5
                  embedUrl = (searchBox.value.slice 0, index) + 'embed/' + (searchBox.value.slice index + 8)
                  dojo.place (dojo.create 'iframe', {
                    'src': embedUrl,
                    'width': '740',
                    'height': '480',
                    'frameborder': '0',
                    'allowfullscreen'
                  }), (dojo.byId 'videoContainer')

                  (dojo.byId 'url').value = searchBox.value

      form method: 'post', style: 'margin: auto', ->
        table style: 'margin: auto;', ->
          tr ->
            td ->
              label for: 'start', ->
                'Start (ms)'
              input name: 'start', style: 'margin-right: 100px'
            td ->
              label for: 'end', ->
                'End (ms)'
              input name: 'end'
              input name: 'url', id: 'url', style: 'display: none'
            td ->
              input type: 'submit', style: 'margin-left: auto; margin-right: auto;'
