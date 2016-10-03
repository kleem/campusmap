observer class InfoBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @mode = conf.mode

    @listen_to @mode, 'change', () => @maybe_hide()
    
    @maybe_hide()

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'search'