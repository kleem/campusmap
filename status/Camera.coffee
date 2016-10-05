observable class Camera
  constructor: (conf) ->
    @init
      events: ['change']

    @n_floors = conf.n_floors

  set_floor: (index) ->
    @floor = index
    @trigger 'change'