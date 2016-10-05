observer class Canvas extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @camera = conf.camera
    @files = conf.files

    @docs = []

    @svg = @d3el.append 'svg'
      .attrs
        viewBox: '-100 1000 9000 5000'

    # ZOOM
    @zoomable_layer = @svg.append 'g'

    @zoom = d3.zoom()
      .scaleExtent([-Infinity,Infinity])
      .on 'zoom', () =>
        @zoomable_layer
          .attrs
            transform: d3.event.transform

    @svg.call @zoom

    # QUEUE
    queue = d3.queue()

    for f in @files
      queue.defer d3.xml, f

    queue.awaitAll @ready

    @listen_to @camera, 'change', () => @switch_view()

  # The main group within each SVG file is added to the Canvas
  ready: (error, docs) =>
    for d,i in docs
      obj = @zoomable_layer.node().appendChild d.getElementsByTagName('g')[0]
      @docs.push {index: i, visible: true, obj: obj}

  switch_view: () =>
    current_index = @camera.get_floor()

    for d,i in @docs
      if i <= current_index
        if not d.visible
          d.visible = true
          d3.select(d.obj).style 'visibility', 'visible'
      else
        if d.visible
          d.visible = false
          d3.select(d.obj).style 'visibility', 'hidden'