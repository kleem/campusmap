observer class SearchBox extends View
  constructor: (conf) ->
    super(conf)
    @init()
      
    @query = conf.query
    @mode = conf.mode
    @selection = conf.selection
    @results = conf.results

    @listen_to @selection, 'change', () => @set_text()

    @innerDiv = @d3el.append 'div'
      .attrs
        class: 'innerSearchBox'
        
    @innerDiv.append 'span'
      .attrs
        class: 'fa-stack fa-lg'
      .html '<i class="fa fa-square-o fa-stack-2x fa-rotate-90 btn-primary"></i><i class="fa fa-level-down fa-stack-1x fa-rotate-270"></i>'
      .on 'click', () =>
        @mode.set 'directions'

    @innerDiv.append 'input'
      .attrs
        class: 'input_search'
        autofocus: true
        placeholder: 'Cerca su CampusMap'
      .on 'blur', () => @results.clear()
      .on 'keyup', () =>
        # all keys different from left, up, right, down arrows
        if d3.event.keyCode in [48..90]
          query_value = d3.select('.input_search').node().value

          if query_value isnt ''
            @query.set query_value
          else
            @results.set null
        # up arrow keys
        else if d3.event.keyCode is 38 and this.query.query isnt ''
          @results.prev()
        # down arrow keys
        else if d3.event.keyCode is 40 and this.query.query isnt ''
          @results.next()
          
  set_text: () ->
    selection = @selection.get()
    
    if selection?
      @innerDiv.select('.input_search').node().value = selection.label
    else
      @innerDiv.select('.input_search').node().value = @query.get()