observer class ResultsBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @query = conf.query
    @selection = conf.selection

    @innerDiv = @d3el.append 'div'
      .attrs
        class: 'innerResultsBox'

    @noResultsBox = @innerDiv.append 'div'
      .attrs
        class: 'noResultsBox'
    
    @noResultsBox.append 'p'
      .attrs
        class: 'results_text'
      .text () -> 'La ricerca non ha prodotto risultati'
          

    @allResultsBox = @innerDiv.append 'div'
      .attrs
        class: 'allResultsBox'

    @listen_to @query, 'results_changed', () =>
      @show_results()

    @listen_to @query, 'query_changed', () =>
      if @query.get_results() is null
        @hide()
  
  show_results: () =>
    results_data = @query.get_results()

    if results_data is null
      return

    if results_data.length is 0
      @show_no_results()
    else
      @hide_no_results()

    results_text = @allResultsBox.selectAll '.results_text'
      .data results_data, (d) -> d.id

    results_text.enter().append 'p'
      .attrs
        class: 'results_text'
      .text (d) -> 
      	d.label
      .on 'click' , (d) => 
        @query.set(d.label)
        @selection.set(d)
        
    results_text.exit().remove()

  show: () =>
    @d3el.classed 'displayed', true

  hide: () =>
    @d3el.classed 'displayed', false

  show_no_results: () =>
    @noResultsBox.classed 'displayed', true
    @allResultsBox.classed 'displayed', false
    @show()

  hide_no_results: () =>
    @noResultsBox.classed 'displayed', false
    @allResultsBox.classed 'displayed', true
    @show()