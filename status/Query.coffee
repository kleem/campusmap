observable class Query
  constructor: (conf) ->
    @init
    	events: ['change']
    @graph = conf.graph

    @query = ''
    @results = []

  set: (query) ->
    @query = query
    @results = @graph.search(@query)
    @trigger 'change'

  get_results: () ->
    return @results