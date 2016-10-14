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

    selection = new Selection
      graph: graph

    #new DirectionsPanel 
    #  parent: this
    #  mode: mode
    #  graph: graph
    
    new SearchPanel 
      parent: this
      mode: mode
      graph: graph
      selection: selection
      
    selection.set null