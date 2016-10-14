observable class Query
  constructor: (conf) ->
    @init
    	events: ['change']
    @graph = conf.graph

    @query = ''
  
  get: () ->
    return @query

  set: (query) ->
    @query = query

    @trigger 'change'
