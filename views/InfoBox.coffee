observer class InfoBox extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @graph = conf.graph