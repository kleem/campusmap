observable class Camera
  constructor: () ->
    @init
      events: ['change']

    @zoom = d3.zoom()
      .scaleExtent([-Infinity,Infinity])
      .on 'zoom', () =>
        @transform = d3.event.transform
        @trigger 'change'

  set_floor: (index) ->
    console.log index
    @floor = index
    @trigger 'change'

  get_floor: () ->
    return @floor

  set_n_floors: (n_floors) ->
    @n_floors = n_floors

  get_n_floors: () ->
    return @n_floors

  get_zoom_behavior: () ->
    return @zoom