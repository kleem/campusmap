observer class Canvas extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @camera = conf.camera
    @selection = conf.selection
    @graph = conf.graph
    @floors = conf.floors

    @docs = []

    @svg = @d3el.append 'svg'
      .attrs
        viewBox: '1200 1000 6000 5000'

    # ZOOM
    @zoomable_layer = @svg.append 'g'
    @svg.call @camera.get_zoom_behavior()

    # SCALES
    @x = d3.scaleLinear()
      .domain [0, 454.22]
      .range [1037.726, 7962.337]

    @y = d3.scaleLinear()
      .domain [0, 454.22]
      .range [7111.417, 182.840]

    # QUEUE
    queue = d3.queue()

    for f in @floors
      queue.defer d3.xml, f.file

    queue.awaitAll @ready

    @listen_to @camera, 'change', () =>
      @zoom()
      @switch_view()

    @listen_to @selection, 'change', () => @locate()

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

  cavalier_conversion: (point) ->

    for i in [0...point.z]
      point.x -= 1.6
      point.y += 1.6

    return point

  locate: () ->
    selection = @selection.get()
    
    if selection?
      room = @graph.get_rooms_from_node selection.id

      if room.length > 0
        centroid = @graph.get_room_centroid room[0]
      
        @placemark = @zoomable_layer.selectAll '.placemark'
          .data [centroid]

        @en_placemark = @placemark.enter().append 'circle'
          .attrs
            class: 'placemark'

        @all_placemark = @en_placemark.merge(@placemark)
        
        @all_placemark
          .attrs
            r: 15
            fill: 'red'
            stroke: 'blue'
            'stroke-width': 2
            cx: (d) => @x @cavalier_conversion(d).x
            cy: (d) => @y @cavalier_conversion(d).y

        @placemark.exit().remove()
     