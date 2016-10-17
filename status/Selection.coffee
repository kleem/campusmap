observable class Selection
  constructor: (conf) ->
    @init
    	events: ['change']
    
  set: (selection) ->
    @selection = selection

    @trigger 'change'

  get: () ->
    return @selection