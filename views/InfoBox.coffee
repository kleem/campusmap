observer class InfoBox extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @graph = conf.graph
    @selection = conf.selection

    @listen_to @selection, 'change', () =>
      @redraw()

    # @room_img = @d3el.append 'img'
    #   .attrs
    #     class: 'img_room'

    # @content = @d3el.append 'div'
    #   .attrs
    #     class: 'content'

  redraw: () ->    
    info = @selection.get()

    if info is null
      @d3el.classed 'hidden', true
      return

    @d3el.classed 'hidden', false

    # img
    image = @d3el.selectAll 'img'
      .data if info? then [info.img] else []

    enter_image = image.enter().append 'img'

    enter_image.merge(image)
      .attrs
        src: (d) -> d

    image.exit().remove()

    # label
    label = @d3el.selectAll '.label'
      .data if info? then [info.label] else []

    enter_label = label.enter().append 'div'
      .attrs
        class: 'label'

    enter_label.merge(label)
      .text (d) -> d

    label.exit().remove()

    # message
    message = @d3el.selectAll '.message'
      .data if info? then [] else ['Nessun Risultato trovato']

    enter_message = message.enter().append 'div'
      .attrs
        class: 'message'

    enter_message.merge(message)
      .text (d) -> d

    message.exit().remove() 
