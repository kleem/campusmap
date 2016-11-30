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

    # LAYERS
    @model_layer = @zoomable_layer.append 'g'
    @writings_layer = @zoomable_layer.append 'g'
    @pois_layer = @zoomable_layer.append 'g'
    @placemarks_layer = @zoomable_layer.append 'g'

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
      @lod()

    @listen_to @camera, 'change_floor', () =>
      @switch_floor()
      @redraw()
      @lod()

    @listen_to @selection, 'change', () =>
      @redraw()
      @select()
      @lod()

  # The main group within each SVG file is added to the Canvas
  ready: (error, docs) =>
    for d,i in docs
      obj = @model_layer.node().appendChild d.getElementsByTagName('g')[0]
      @docs.push {index: i, visible: true, obj: obj}

  zoom: () ->
    @zoomable_layer
      .attrs
        transform: @camera.transform

  lod: () ->
    @placemarks_layer.selectAll '.placemark > g'
      .attrs
        transform: "scale(#{1/@camera.transform.k})"

    @pois_layer.selectAll '.poi > g'
      .attrs
        transform: "scale(#{1/@camera.transform.k})"

    @writings_layer.selectAll '.writing'
      .classed 'hidden', (if @camera.transform.k > 4.5 then false else true)

    @pois_layer.selectAll '.poi .label'
      .classed 'hidden', (if @camera.transform.k > 3 then false else true)

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

  select: () ->
    # TODO zoom animation (should be done by Camera to trigger change events)
    # TODO better name
    # selection = @selection.get()

    # if selection?
      # redraw the placemarks on the current floor
      # @redraw_placemarks @graph.get_nodes_at_floor(@camera.get_current_floor().i)

#      room = if selection.type is 'person' then @graph.get_rooms_from_node(selection.id)[0] else selection
#
#
#      # center canvas to selection
#      centroid = @graph.get_room_centroid room
#
#      if centroid?
#        t = @camera.transform
#
#        if !t?
#          t = d3.zoomTransform(this)
#          t.k = 1
#
#        t.x = -@x(centroid.x)*t.k + @min_x + @vb_w/2
#        t.y = -@y(centroid.y)*t.k + @min_y + @vb_h/2
#
#        @zoomable_layer.call(@camera.zoom.transform, t)

  redraw: () ->
    # FIXME this is called twice when both selection and floor change

    nodes_at_current_floor = @graph.get_nodes_at_floor(@camera.get_current_floor().id)

    @redraw_pois nodes_at_current_floor.filter (d) -> d.x? and d.y?
    @redraw_areas nodes_at_current_floor.filter (d) -> d.centroid?

    # FIXME this hides points in other floors, need a way to show them, at least in the nav controls
    @redraw_placemarks @graph.get_points_from_node(@selection.get()).filter((d) => d.floor is @camera.get_current_floor().id)

  redraw_pois: (data) ->
    pois = @pois_layer.selectAll '.poi'
      .data data, (d) -> d.id

    en_pois = pois.enter().append 'g'
      .attrs
        class: 'poi'
        transform: (d) =>
          point = {x: d.x, y: d.y, z: (if d.floor is 'T' then 0 else parseInt(d.floor))}
          "translate(#{@x(@to_cavalier(point).x)}, #{@y(@to_cavalier(point).y)})"
      .on 'click', (d) => @selection.set d

    inner_g = en_pois.append 'g'

    inner_g.append 'circle'
      .attrs
        class: 'background'
        r: 60
        cy: 5
      .append 'title'
        .text (d) -> d.label

    inner_g.append 'circle'
      .attrs
        class: 'foreground'
        r: 60

    inner_g.append 'foreignObject'
      .attrs
        x: -50
        y: -35
        width: 100
        height: 100
      .html (d) -> "<i class='icon fa fa-fw #{d.icon}'></i>"

    inner_g.append 'text'
      .attrs
        class: 'background label'
        'text-anchor': 'start'
        dy: '0.35em'
        x: 80
      .text (d) -> d.label

    inner_g.append 'text'
      .attrs
        class: 'foreground label'
        'text-anchor': 'start'
        dy: '0.35em'
        x: 80
      .text (d) -> d.label

    en_pois.append 'title'
      .text (d) -> d.label

    pois.exit().remove()

  redraw_areas: (data) ->
    # Room writings
    writings = @writings_layer.selectAll '.writing'
      .data data.filter((d) -> not(d.x? and d.y?)), (d) -> d.id

    en_writings = writings.enter().append 'g'
      .attrs
        class: 'writing'
        transform: (d) => "translate(#{@x(@to_cavalier(d.centroid).x)}, #{@y(@to_cavalier(d.centroid).y)})"
      .on 'click', (d) => @selection.set d

    en_writings.append 'text'
      .attrs
        'text-anchor': 'middle'
        dy: '0.35em'
      .text (d) -> d.label

    all_writings = en_writings.merge(writings)
      .classed 'hidden', (d) => @camera.transform.k < 4.5

    writings.exit().remove()

  redraw_placemarks: (data) ->
    # Placemarks
    placemarks = @placemarks_layer.selectAll '.placemark'
      .data data, (d,i) -> "#{d.node.id}_#{i}"

    en_placemarks = placemarks.enter().append 'g'
      .attrs
        class: 'placemark'

    inner_g = en_placemarks.append 'g'
    inner_inner_g = inner_g.append 'g'
      .attrs
        transform: 'scale(10) translate(-10, -34)'

    inner_inner_g.append 'path'
      .attrs
        class: 'marker'
        d: 'm 9.8764574,31.79142 c -0.338425,-0.310215 -3.09702,-5.15494 -4.9481,-8.689995 C 1.6820824,16.901925 -0.00231761,12.48891 2.3933246e-6,10.189485 0.00400239,6.4328055 2.1654374,2.8789055 5.4922974,1.1597255 7.0703674,0.34424546 8.4572874,0.00391046 10.218242,3.5456334e-5 12.022222,-0.00396454 13.401907,0.33017046 15.006572,1.1595805 c 3.32727,1.719785 5.48861,5.27318 5.492405,9.0299045 0.002,2.29401 -1.69247,6.737965 -4.920215,12.901435 -1.85322,3.53877 -4.61567,8.388045 -4.956345,8.7005 -0.11646,0.106815 -0.25763,0.171875 -0.372925,0.171875 -0.11527,0 -0.2565346,-0.06509 -0.3730346,-0.171875 z'

    inner_inner_g.append 'path'
      .attrs
        class: 'circle'
        d: 'm -7.2699413,6.9825382 a 7.943903,7.943903 0 1 1 -15.8878057,0 7.943903,7.943903 0 1 1 15.8878057,0 z'
        transform: 'matrix(1.0113978,0,0,1.0113978,25.605491,3.1820663)'

    inner_inner_g.append 'foreignObject'
      .attrs
        width: 20
        height: 20
        transform: 'translate(3.5,5.4)'
      .html (d) -> "<i class='icon fa fa-fw #{d.node.icon}'></i>"

    all_placemarks = en_placemarks.merge(placemarks)
      .attrs
        transform: (d) =>
          point = @to_cavalier(d)
          return "translate(#{@x(point.x)}, #{@y(point.y)})"

    placemarks.exit().remove()

  to_cavalier: (point) ->
    return {
      x: point.x - (Math.cos(Math.PI/4) * 4.5) * point.z
      y: point.y + (Math.sin(Math.PI/4) * 4.5) * point.z
    }
