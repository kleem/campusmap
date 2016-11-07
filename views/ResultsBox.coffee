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
        class: 'no_results'
      .text () -> 'La ricerca non ha prodotto risultati'      

    @allResultsBox = @innerDiv.append 'div'
      .attrs
        class: 'allResultsBox'

    @ulResultsBox = @allResultsBox.append 'div'
      .attrs
        class: 'ulResultsBox'
    
    @listen_to @results, 'change', () => @show_results()

  show_results: () =>
    results_data = @results.get()
    query_string = @query.get()
    if query_string.split ' '
      query_string_capitalize = query_string.replace(/\w\S*/g, (txt) -> txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase())
    else query_string_capitalize = query_string[0].toUpperCase() + query_string[1..-1].toLowerCase()

    if results_data is null
      @hide()
      return
    
    if results_data.length is 0
      @show_no_results()
    else
      @hide_no_results()

    results = @ulResultsBox.selectAll '.result'
      .data results_data, (d,i) -> d.id

    results_enter = results.enter().append 'div'
      .attrs
        class: 'result'
      .on 'click' , (d) =>
        @results.set_focused d
        @results.clear()
      
    results_enter.merge(results)
      .classed 'focused', (d) => @results.check_focused d
      .html (d) -> 
        icon = switch d.type
          when 'person' then "<i class='fa fa-user'></i>"
          when 'room' then "<i class='fa fa-map-marker'></i>"
          when 'bicycle' then "<i class='fa fa-bicycle'></i>"
          when 'bus' then "<i class='fa fa-bus'></i>"
          when 'building' then "<i class='fa fa-building'></i>"
        
        return "#{icon} #{d.label.replace(query_string_capitalize,"<span class='bold'>#{query_string_capitalize}</span>")}"
    
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