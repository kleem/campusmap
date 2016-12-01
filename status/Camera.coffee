observable class Camera
  constructor: (conf) ->
    @init
      events: ['change', 'change_floor']

    @floors = conf.floors
    @floors_index = {}
    @floors.forEach (d) =>
      @floors_index[d.id] = d

    @transform = d3.zoomTransform(this)

    @zoom = d3.zoom()
      .scaleExtent [0.8, 8]
      .on 'zoom', () =>
        @transform = d3.event.transform
        @trigger 'change'

  get_floors: () ->
    return @floors

  set_current_floor: (d) ->
    if d isnt @current_floor
      @current_floor = d
      @trigger 'change_floor'

  set_current_floor_id: (id) ->
    @set_current_floor @floors_index[id]

  get_current_floor: () ->
    return @current_floor

  get_zoom_behavior: () ->
    return @zoom

  is_last_floor: (floor) ->
    return @floors[@floors.length-1] is floor