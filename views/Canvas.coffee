observer class Canvas extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @camera = conf.camera
    @selection = conf.selection
    @graph = conf.graph
    @floors = conf.floors

    @docs = []
    @placemark_radius = 50

    @min_x = 1200
    @min_y = 1000
    @vb_w = 6000
    @vb_h = 5000

    @svg = @d3el.append 'svg'
      .attrs
        viewBox: "#{@min_x} #{@min_y} #{@vb_w} #{@vb_h}"

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
      @switch_floor()

    @listen_to @selection, 'change', () => @select()

  # The main group within each SVG file is added to the Canvas
  ready: (error, docs) =>
    for d,i in docs
      obj = @zoomable_layer.node().appendChild d.getElementsByTagName('g')[0]
      @docs.push {index: i, visible: true, obj: obj}

  redraw_placemarks: (data) ->
    selection = @selection.get()

    if selection?
      room = if selection.type isnt 'room' then @graph.get_rooms_from_node(selection.id)[0] else selection
    else
      room = null

    @placemarks = @zoomable_layer.selectAll '.placemark'
      .data data, (d) -> d.id

    @en_placemarks = @placemarks.enter().append 'g'
      .attrs
        class: 'placemark'
        transform: (d) => "translate(#{@x(@to_cavalier(d.centroid).x)}, #{@y(@to_cavalier(d.centroid).y)})"
      .on 'click', (d) => @selection.set d
      .classed 'hidden', (d) -> d isnt room

    @en_placemarks.append 'circle'
      .attrs
        r: @placemark_radius

    @en_placemarks.append 'text'
      .attrs
        class: 'halo'
        'text-anchor': 'start'
        x: 7
        dy: '0.35em'
      .text (d) -> d.label

    @en_placemarks.append 'text'
      .attrs
        'text-anchor': 'start'
        x: 7
        dy: '0.35em'
      .text (d) -> d.label

    selected_points = @graph.get_points_from_node selection

    @all_placemarks = @en_placemarks.merge(@placemarks)
      .classed 'selected', (d) -> d in selected_points
      .classed 'hidden', (d) => d isnt room and @camera.transform.k < 4.5

    @placemarks.exit().remove()

  zoom: () =>
    @zoomable_layer
      .attrs
        transform: @camera.transform

    @zoomable_layer.selectAll '.placemark circle'
      .attrs
        r: @placemark_radius / @camera.transform.k

    @zoomable_layer.selectAll '.placemark'
      .classed 'hidden', (if @camera.transform.k > 4.5 then false else true)

  switch_floor: () =>
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

    @redraw_placemarks @graph.get_rooms_at_floor(current_index)

  to_cavalier: (point) ->
    return {
      x: point.x - (Math.cos(Math.PI/4) * 4.5) * point.z
      y: point.y + (Math.sin(Math.PI/4) * 4.5) * point.z
    }

  select: () ->
    selection = @selection.get()
    
    if selection?
      room = if selection.type isnt 'room' then @graph.get_rooms_from_node(selection.id)[0] else selection

      current_index = @camera.get_current_floor().i
      @redraw_placemarks @graph.get_rooms_at_floor(current_index)

      # center canvas to selection
      centroid = @graph.get_room_centroid room
      t = @camera.transform

      if !t?
        t = d3.zoomTransform(this)
        t.k = 1

      t.x = -@x(centroid.x)*t.k + @min_x + @vb_w/2
      t.y = -@y(centroid.y)*t.k + @min_y + @vb_h/2

      @zoomable_layer.call(@camera.zoom.transform, t)