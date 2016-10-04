observer class InfoBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @mode = conf.mode
    @graph = conf.graph

    @listen_to @mode, 'change', () => @maybe_hide()
    
    @maybe_hide()

    console.log @graph.nodes

  maybe_hide: () ->
    @d3el.classed 'hidden', @mode.get() isnt 'search'

