observable class Results
  constructor: (conf) ->
    @init
      events: ['change']

    @results = []
    @focused = null
  
  get: () ->
    return @results

  set: (results) ->
    @results = results
    @trigger 'change'
