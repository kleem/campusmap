observable class Mode
  constructor: (conf) ->
    @init
      events: ['change']

  set: (mode) ->
    @mode = mode
    @trigger 'change'
    return this

  get: () ->
    return @mode