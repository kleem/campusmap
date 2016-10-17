observer class SearchPanel extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @mode = conf.mode
    @graph = conf.graph
    @selection = conf.selection

    @query = new Query
      graph: @graph

    @results = new Results

    results_box = new ResultsBox
      parent: this
      query: @query
      results: @results
      selection: @selection

    new SearchBox 
      parent: this
      query: @query
      mode: @mode
      results: @results
      selection: @selection

    new InfoBox 
      parent: this
      graph: @graph
      selection: @selection

    @listen_to @results, 'new_focus', () => @selection.set @results.get_focused()

    @listen_to @query, 'change', () =>
      results = @graph.search @query.query
      @results.set results

    @listen_to @mode, 'change', () => @maybe_hide()

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'search'