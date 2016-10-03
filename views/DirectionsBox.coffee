observer class DirectionsBox extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @mode = conf.mode

    @d3el.append 'button'
      .text 'x'
      .on 'click', () =>
        @mode.set 'search'

    @listen_to @mode, 'change', () => @maybe_hide()
      
    @maybe_hide()

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'directions'