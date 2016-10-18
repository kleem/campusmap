class Graph
  constructor: (conf) ->
    @nodes = conf.nodes
    @links = conf.links # sources are nodes such as persons or printers while targets are rooms 

    @max_results = 5

  search: (string) ->
    return @nodes.filter((n) -> n.label.toLowerCase().indexOf(string.toLowerCase()) is 0 and string isnt '').slice(0, @max_results)

  get_rooms_from_node: (node_id) ->
    results = @links.filter((l) -> l.source is node_id).map (l) -> l.target

    return @nodes.filter (n) -> n.id in results