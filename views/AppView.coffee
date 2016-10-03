class AppView extends View
  constructor: (conf) ->
    super(conf)

    mode = new Mode
    mode.set 'search'

    new Canvas 
      parent: this

    new SearchBox 
      parent: this
      mode: mode

    new InfoBox 
      parent: this
      mode: mode

    new DirectionsBox 
      parent: this
      mode: mode

    

