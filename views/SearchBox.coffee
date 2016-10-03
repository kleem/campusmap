observer class SearchBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @mode = conf.mode

    innerDiv = @d3el.append 'div'
      .attrs
        class: 'innerSearchBox'
      .text 'CIAO'


    innerDiv.append 'button'
      .text 'dir'
      .on 'click', () =>
        @mode.set 'directions'

    @listen_to @mode, 'change', () => @maybe_hide()
    
    @maybe_hide()

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'search'
