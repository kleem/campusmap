observer class Canvas extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @camera = conf.camera
    @floors = conf.floors

    @docs = []

    @svg = @d3el.append 'svg'
      .attrs
        viewBox: '-100 1000 11000 7000'

    # ZOOM
    @zoomable_layer = @svg.append 'g'
    @svg.call @camera.get_zoom_behavior()

    # QUEUE
    queue = d3.queue()

    for f in @floors
      queue.defer d3.xml, f.file

    queue.awaitAll @ready

    @listen_to @camera, 'change', () =>
      @zoom()
      @switch_view()

  # The main group within each SVG file is added to the Canvas
  ready: (error, docs) =>
    for d,i in docs
      obj = @zoomable_layer.node().appendChild d.getElementsByTagName('g')[0]
      @docs.push {index: i, visible: true, obj: obj}

  zoom: () =>
    @zoomable_layer
      .attrs
        transform: @camera.transform

  switch_view: () =>
    current_index = @camera.get_current_floor().i

    for d,i in @docs
      if i <= current_index
        if not d.visible
          d.visible = true
          d3.select(d.obj).style 'visibility', 'visible'
      else
        if d.visible
          d.visible = false
          d3.select(d.obj).style 'visibility', 'hidden'
