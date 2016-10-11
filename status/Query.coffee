observable class Query
  constructor: (conf) ->
    @init
    	events: ['query_changed','results_changed']
    @graph = conf.graph

    @query = ''
    @results = []
    @selected_result = null
  
  get: () ->
    return @query

  set: (query) ->
    @query = query
    @trigger 'query_changed'

  execute: () ->  
    @results = null
    if @query is ''
      @results = null
    else
      @results = @graph.search(@query)
    @trigger 'results_changed'

  get_results: () ->
    return @results

  get_selected_result: () ->
    return @selected_result

  set_selected_result: (value) ->
    @selected_result = value

  select_result: (index) ->
    @selected_result = index % @results.length
    @set(@results[@selected_result].label)
