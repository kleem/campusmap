class AppView extends View
  constructor: (conf) ->
    super(conf)

    mode = new Mode
    mode.set 'search'

    graph = new Graph

    query = new Query
      graph: graph

    new SearchBox 
      parent: this
      mode: mode
      query: query 

    new Canvas 
      parent: this

    new InfoBox 
      parent: this
      mode: mode
      graph: graph

    new DirectionsBox 
      parent: this
      mode: mode

    new ResultsBox
      parent: this
      mode: mode
      query: query

    

