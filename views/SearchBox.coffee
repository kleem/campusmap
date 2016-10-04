observer class SearchBox extends View
  constructor: (conf) ->
    super(conf)
    @init()
      
    @query = conf.query
    @mode = conf.mode

    @listen_to @mode, 'change', () => @maybe_hide()

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
        placeholder: 'Cerca su CampusMap'
      .on 'keyup', () => 
        @query.set(d3.select('.input_search').node().value)

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'search'