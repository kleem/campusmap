observer class Canvas extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @camera = conf.camera

    @files = conf.files

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
    for d in docs
      @zoomable_layer.node().appendChild d.getElementsByTagName('g')[0]

  switch_view: () =>
    @zoomable_layer.selectAll('g').style 'visibility', 'visible'

    groups = @zoomable_layer.selectAll('g').filter (d,i) => i > @camera.get_floor()
    groups.style 'visibility', 'hidden'
