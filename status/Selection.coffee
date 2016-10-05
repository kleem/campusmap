observable class Selection
  constructor: (conf) ->
    @init
    	events: ['change']

    @graph = conf.graph
    
  set: (selection) ->
    @selection = selection
    @trigger 'change'

  get: () ->
    return @selection