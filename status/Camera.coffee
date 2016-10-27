observable class Camera
  constructor: (conf) ->
    @init
      events: ['change']

    @floors = conf.floors
    @floors_index = {}
    @floors.forEach (d) =>
      @floors_index[d.id] = d

    @zoom = d3.zoom()
      .scaleExtent [0.5, 8]
      .on 'zoom', () =>
        @transform = d3.event.transform
        @trigger 'change'

  get_floors: () ->
    return @floors

  set_current_floor: (d) ->
    @current_floor = d
    @trigger 'change'

  set_current_floor_id: (id) ->
    @set_current_floor @floors_index[id]

  get_current_floor: () ->
    return @current_floor

  get_zoom_behavior: () ->
    return @zoom
