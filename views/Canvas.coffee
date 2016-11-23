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

    # Room writings
    writings = @zoomable_layer.selectAll '.writing'
      .data data, (d) -> d.id

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

    # Placemarks
    selected_points = @graph.get_points_from_node selection

    placemarks = @zoomable_layer.selectAll '.placemark'
      .data data, (d) -> d.id

    en_placemarks = placemarks.enter().append 'g'
      .attrs
        class: 'placemark'
        transform: (d) => "translate(#{@x(@to_cavalier(d.centroid).x)}, #{@y(@to_cavalier(d.centroid).y)})"

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

    # inner_inner_g.append 'text'
    #   .attrs
    #     'fill': '#303030'
    #     'font-size': 10
    #     'font-family': 'FontAwesome'
    #     'text-anchor': 'middle'
    #     x: 10.2
    #     y: 10.35
    #     dy: '0.35em'
    #   .text '\uf007'

    all_placemarks = en_placemarks.merge(placemarks)
      .classed 'hidden', (d) -> d not in selected_points

    placemarks.exit().remove()

  redraw_pois: (data) ->
    
    pois = @zoomable_layer.selectAll '.poi'
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
        r: 40
      .append 'title'
        .text (d) -> d.label

    inner_g.append 'text'
      .attrs
        'text-anchor': 'start'
        dy: '0.35em'
        x: 60
      .text (d) -> d.label

    pois.exit().remove()

  lod: () ->
    @zoomable_layer.selectAll '.placemark > g'
      .attrs
        transform: "scale(#{1/@camera.transform.k})"

    @zoomable_layer.selectAll '.poi > g'
      .attrs
        transform: "scale(#{1/@camera.transform.k})"

    @zoomable_layer.selectAll '.writing'
      .classed 'hidden', (if @camera.transform.k > 4.5 then false else true)

    @zoomable_layer.selectAll '.poi text'
      .classed 'hidden', (if @camera.transform.k > 3 then false else true)

  zoom: () =>
    @zoomable_layer
      .attrs
        transform: @camera.transform

    @lod()

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
    @redraw_pois @graph.get_pois_at_floor(current_index)

    @lod()

  to_cavalier: (point) ->
    return {
      x: point.x - (Math.cos(Math.PI/4) * 4.5) * point.z
      y: point.y + (Math.sin(Math.PI/4) * 4.5) * point.z
    }

  select: () ->
    selection = @selection.get()
    
    if selection?
      room = if selection.type is 'person' then @graph.get_rooms_from_node(selection.id)[0] else selection

      current_index = @camera.get_current_floor().i
      @redraw_placemarks @graph.get_rooms_at_floor(current_index)

      # center canvas to selection
      centroid = @graph.get_room_centroid room
      
      if centroid?
        t = @camera.transform

        if !t?
          t = d3.zoomTransform(this)
          t.k = 1

        t.x = -@x(centroid.x)*t.k + @min_x + @vb_w/2
        t.y = -@y(centroid.y)*t.k + @min_y + @vb_h/2

        @zoomable_layer.call(@camera.zoom.transform, t)