observer class AppView extends View
  constructor: (conf) ->
    super(conf)
    @init()

    mode = new Mode
    mode.set 'search'

    floors = [
      {id: 'T', label: 'Piano Terra', file: 'data/cnr_cavalier_0.svg'},
      {id: '1', label: 'Primo piano', file: 'data/cnr_cavalier_1.svg'},
      {id: '2', label: 'Secondo piano', file: 'data/cnr_cavalier_2.svg'},
      {id: '3', label: 'Tetto', file: 'data/cnr_cavalier_3.svg'}
    ]
    floors.forEach (d,i) -> d.i = i

    camera = new Camera
      floors: floors

    nav_controls = new NavControls
      parent: this
      camera: camera

    camera.set_current_floor_id '3'

    graph = new Graph
      nodes: conf.graph.nodes
      links: conf.graph.links
      rooms: conf.rooms
      centroids: conf.centroids

    selection = new Selection
      graph: graph

    new Canvas
      parent: this
      camera: camera
      selection: selection
      graph: graph
      floors: floors

    user = new User

    inituser = new InitUser
      parent: this
      user: user

    weather_data = new WeatherData

    new WeatherInfo
      parent: this
      weather_data: weather_data

    new SearchPanel
      parent: this
      mode: mode
      graph: graph
      selection: selection
      weather_data: weather_data

    selection.unset()

    @listen_to selection, 'change', () ->
      s = selection.get()

      if s? and s.floor?
        camera.set_current_floor_id s.floor
      else
        camera.set_current_floor_id '3'
