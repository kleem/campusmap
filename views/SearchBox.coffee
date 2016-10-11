observer class SearchBox extends View
  constructor: (conf) ->
    super(conf)
    @init()
      
    @query = conf.query
    @mode = conf.mode
    @selection = conf.selection
    @results_box = conf.results_box

    @listen_to @query, 'query_changed', () => @change_value()

    innerDiv = @d3el.append 'div'
      .attrs
        class: 'innerSearchBox'
        
    innerDiv.append 'span'
      .attrs
        class: 'fa-stack fa-lg'
      .html '<i class="fa fa-square-o fa-stack-2x fa-rotate-90 btn-primary"></i><i class="fa fa-level-down fa-stack-1x fa-rotate-270"></i>'
      .on 'click', () =>
        @mode.set 'directions'

    innerDiv.append 'input'
      .attrs
        class: 'input_search'
        autofocus: true
        placeholder: 'Cerca su CampusMap'
      .on 'keyup', () =>
        if d3.event.keyCode is 40
          result_index = @query.get_selected_result()
          @query.select_result if result_index is null then 0 else result_index+1
        else if d3.event.keyCode is 38
          result_index = @query.get_selected_result()
          @query.select_result if result_index is null or result_index is 0 then @query.get_results().length-1 else result_index-1
        else if d3.event.keyCode is 13
          if @query.get_selected_result() isnt null
            @selection.set(@query.get_results()[@query.get_selected_result()])
          else
            @selection.set(@query.get_results()[0])
          @results_box.hide()
        else if d3.event.keyCode not in [37,39]
          @query.set_selected_result null
          @query.set(d3.select('.input_search').node().value)
          @query.execute()
          
  change_value: () ->
    d3.select('.input_search').node().value = @query.get()