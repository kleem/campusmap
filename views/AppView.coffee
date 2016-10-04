class AppView extends View
  constructor: (conf) ->
    super(conf)

    mode = new Mode
    mode.set 'search'

    nav_controls = new NavControls
      parent: this
      floors: [{label: 'P0'}, {label: 'P1'}, {label: 'P2'}, {label: 'P3'}]

    new Canvas 
      parent: this
      nav_controls: nav_controls
      files: ['data/cnr_0.svg', 'data/cnr_1.svg', 'data/cnr_2.svg', 'data/cnr_3.svg']

    new SearchBox 
      parent: this
      mode: mode

    new InfoBox 
      parent: this
      mode: mode

    new DirectionsBox 
      parent: this
      mode: mode

    

