observable class Results
  constructor: (conf) ->
    @init
      events: ['change']

    @results = null
    @focused = null
  
  get: () ->
    return @results

  set: (results) ->
    @results = results
    @focused = null

    @trigger 'change'

  clear: () ->
    @set null
