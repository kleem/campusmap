observer class InfoBox extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @graph = conf.graph
    @selection = conf.selection

    @listen_to @selection, 'change', () =>
      @redraw()

    @room_img = @d3el.append 'img'
      .attrs
        class: 'img_room'

    @content = @d3el.append 'div'
      .attrs
        class: 'content'

  redraw: () ->
    
    info = @selection.get()

    if info is null
      @d3el.classed 'hidden', true
      return

    @d3el.classed 'hidden', false
   
    @content.text info.label

    @room_img.attr 'src', "img/room_2.jpg"
