observable class Query
  constructor: (conf) ->
    @init
    	events: ['query_changed','results_changed']
    @graph = conf.graph

    @query = ''
    @results = []

  set: (query) ->
    @query = query
    @results = null
    @trigger 'query_changed'

  execute: () ->  
    if @query is ''
      @results = null
    else
      @results = @graph.search(@query)
    @trigger 'results_changed'

  get_results: () ->
    return @results

  get: () ->
    return @query