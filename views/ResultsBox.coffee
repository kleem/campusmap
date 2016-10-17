observer class ResultsBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @query = conf.query
    @selection = conf.selection
    @results = conf.results

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

    @ulResultsBox = @allResultsBox.append 'ul'
      .attrs
        class: 'ulResultsBox'
    
    @listen_to @results, 'change', () => @show_results()

  show_results: () =>
    results_data = @results.get()

    if results_data is null
      @hide()
      return
    
    if results_data.length is 0
      @show_no_results()
    else
      @hide_no_results()

    results = @ulResultsBox.selectAll '.result'
      .data results_data, (d,i) -> d.id

    results_enter = results.enter().append 'li'
      .attrs
        class: 'result'
        value: (d) -> d.id
      .text (d) -> d.label
      .on 'click' , (d) => 
        @query.set d.label
        @selection.set d

    results_enter.merge(results)
      .classed 'focused', (d) => @results.check_focused d

    results.exit().remove()

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