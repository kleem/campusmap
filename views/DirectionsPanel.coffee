observer class DirectionsPanel extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @mode = conf.mode
    @graph = conf.graph

    @query = new Query
      graph: @graph

    @listen_to @mode, 'change', () => @maybe_hide()

    innerDiv = @d3el.append 'div'
      .attrs
        class: 'innerDirectionsPanel'
        
    innerDiv.append 'span'
      .html '<i class="fa fa-times-circle-o"></i>'
      .on 'click', () =>
        @mode.set 'search'

    innerDiv.append 'input'
      .attrs
        class: 'input_search_from'
        placeholder: 'Punto di partenza'
      .on 'keyup', () =>
        @query.set(d3.select('.input_search_from').node().value)

    innerDiv.append 'input'
      .attrs
        class: 'input_search_to'
        placeholder: 'Punto di arrivo'
      .on 'keyup', () => 
        @query.set(d3.select('.input_search_to').node().value)
    

    new ResultsBox
      query: @query
      parent: this

    @maybe_hide()

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'directions'