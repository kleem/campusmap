observer class ResultsBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @query = conf.query
    @selection = conf.selection
    @object_results = {}


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
    
    @listen_to @query, 'results_changed', () =>
      @show_results()

    @listen_to @query, 'query_changed', () =>
      @ulResultsBox.selectAll('li.result').classed('highlighted', false)
      
      if @query.get_selected_result() isnt null
        @ulResultsBox.select("li.result:nth-of-type(#{@query.get_selected_result()+1})").classed('highlighted', true)
      
      if @query.get_results() is null
        @hide()

  show_results: () =>
    results_data = @query.get_results()
    console.log results_data
    if results_data is null
      @hide()
      return

    for i in results_data
      @object_results[i.id] = i
    ###
    if results_data.length < 5
      console.log 'f'
      @ulResultsBox
        .attrs
          size: results_data.length
      console.log d3.select('.ulResultsBox').attr('size')
    else
      @ulResultsBox
        .attrs
          size: 5
    ###

    if results_data.length is 0
      @show_no_results()
    else
      @hide_no_results()

    @results_text = @ulResultsBox.selectAll '.result'
      .data results_data, (d,i) -> d.id

    @results_text.enter().append 'li'
      .attrs
        class: 'result'
        value: (d) -> d.id
      .text (d) -> d.label
      .on 'click' , (d) => 
        @query.set d.label
        @selection.set d

    @results_text.exit().remove()

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

  set_focus: (el) ->
    @ulResultsBox.select('li.result:nth-of-type('+el+')').classed("highlighted",true)