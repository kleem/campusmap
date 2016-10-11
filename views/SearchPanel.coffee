observer class SearchPanel extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @mode = conf.mode
    @graph = conf.graph
    @selection = conf.selection

    @query = new Query
      graph: @graph

    results_box = new ResultsBox
      parent: this
      query: @query
      selection: @selection

    new SearchBox 
      parent: this
      query: @query
      mode: @mode
      results_box: results_box
      selection: @selection

    new InfoBox 
      parent: this
      graph: @graph
      selection: @selection

    @listen_to @mode, 'change', () => @maybe_hide()

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'search'