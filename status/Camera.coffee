observable class Camera
  constructor: () ->
    @init
      events: ['change']

  set_floor: (index) ->
    @floor = index
    @trigger 'change'

  get_floor: () ->
    return @floor

  set_n_floors: (n_floors) ->
    @n_floors = n_floors

  get_n_floors: () ->
    return @n_floors