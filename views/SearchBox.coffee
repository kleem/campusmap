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

    @input = @innerDiv.append 'input'
      .attrs
        class: 'input_search'
        autofocus: true
        placeholder: 'Cerca su CampusMap'
      .on 'blur', () =>
        # solve the preemption of blur with the click event
        setTimeout (() => @results.clear()), 150
      .on 'focus click', () =>
        text = @get_text()

        if text isnt ''
          @query.set text
      .on 'keyup', () =>
        # all keys different from left, up, right, down arrows
        if d3.event.keyCode in [48..90].concat([8,46])
          query_value = @input.node().value

          if query_value isnt ''
            @query.set query_value
          else
            @results.set null
        # enter key
        else if d3.event.keyCode is 13
          @results.clear()
        # up arrow keys
        else if d3.event.keyCode is 38 and this.query.query isnt ''
          @results.prev()
        # down arrow keys
        else if d3.event.keyCode is 40 and this.query.query isnt ''
          @results.next()

    @innerDiv.append 'div'
      .attrs
        class: 'directions_button'
      .html '<i class="fa fa-arrow-circle-right fa-2x"></i>'
      .on 'click', () =>
        @mode.set 'directions'

  set_text: () ->
    selection = @selection.get()

    if selection?
      @input.node().value = selection.label
    else
      @input.node().value = @query.get()

  get_text: () ->
    return @input.node().value
