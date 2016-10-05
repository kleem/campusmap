observer class SearchPanel extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @mode = conf.mode
    @graph = conf.graph

    @query = new Query
      graph: @graph

    new SearchBox 
      parent: this
      query: @query
      mode: @mode 

    new ResultsBox
      parent: this
      query: @query

    new InfoBox 
      parent: this
      graph: @graph

    @listen_to @mode, 'change', () => @maybe_hide()

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'search'