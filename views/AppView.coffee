class AppView extends View
  constructor: (conf) ->
    super(conf)

    mode = new Mode
    mode.set 'search'

    camera = new Camera

    nav_controls = new NavControls
      parent: this
      camera: camera
      floors: [{label: 'P0'}, {label: 'P1'}, {label: 'P2'}, {label: 'P3'}]

    camera.set_n_floors 3
    camera.set_floor 3

    new Canvas 
      parent: this
      camera: camera
      files: ['data/cnr_0.svg', 'data/cnr_1.svg', 'data/cnr_2.svg', 'data/cnr_3.svg']

    graph = new Graph

    query = new Query
      graph: graph

    new SearchBox 
      parent: this
      mode: mode
      query: query 

    new InfoBox 
      parent: this
      mode: mode
      graph: graph

    new DirectionsBox 
      parent: this
      mode: mode
      query: query

    new ResultsBox
      parent: this
      mode: mode
      query: query

