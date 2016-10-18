observer class AppView extends View
  constructor: (conf) ->
    super(conf)
    @init()

    mode = new Mode
    mode.set 'search'

    floors = [
      {id: 'T', file: 'data/cnr_no_borders_0.svg'},
      {id: '1', file: 'data/cnr_no_borders_1.svg'},
      {id: '2', file: 'data/cnr_no_borders_2.svg'},
      {id: '3', file: 'data/cnr_no_borders_3.svg'}
    ]
    floors.forEach (d,i) -> d.i = i

    camera = new Camera
      floors: floors

    nav_controls = new NavControls
      parent: this
      camera: camera

    camera.set_current_floor_id '3'

    new Canvas
      parent: this
      camera: camera
      floors: floors

    graph = new Graph
      nodes: conf.graph.nodes
      links: conf.graph.links

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

    @listen_to selection, 'change', () ->
      s = selection.get()

      if s? and s.floor?
        camera.set_current_floor_id s.floor
      else
        camera.set_current_floor_id '3'
