class Graph
  constructor: (conf) ->
    @nodes = conf.nodes
    @links = conf.links # sources are nodes such as persons or printers while targets are rooms 

    @centroids = {}
    @rooms = {}

    conf.centroids.forEach (c) => @centroids[c.id] = c
    conf.rooms.forEach (r) => @rooms[r.label] = {id: r.id, label: r.label, x: parseFloat(@centroids[r.id].x), y: parseFloat(@centroids[r.id].y), z: parseInt(@centroids[r.id].z)}

    @max_results = 5

  search: (string) ->

    if string isnt ''
      return @nodes
        .filter (n) -> 
          tokens = n.label.toLowerCase().split(/[ |-]/)

          return (tokens
            .map (t) -> t.indexOf(string.toLowerCase()) is 0
            .reduce (a, b) -> a or b) or n.label.toLowerCase().indexOf(string.toLowerCase()) is 0
        .slice(0, @max_results)

    else
      return []

  get_rooms_from_node: (node_id) ->
    results = @links.filter((l) -> l.source is node_id).map (l) -> l.target

    return @nodes.filter (n) -> n.id in results

  get_nodes_from_room: (room_id) ->
    node_ids = @links.filter((l) -> l.target is room_id).map (l) -> l.source

    return @nodes.filter (n) -> n.id in node_ids

  get_room_centroid: (room) ->
    return @rooms[room.label]