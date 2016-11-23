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

  floor_to_z: (floor) ->
    return if floor is 'T' then 0 else parseInt(floor)

  get_rooms_at_floor: (floor) ->
    return @nodes.filter (n) => 
      n.centroid = @get_room_centroid n
      return n.type in ['room', 'bicycle', 'bus'] and @floor_to_z(n.floor) is floor and n.centroid?

  get_pois_at_floor: (floor) ->
    return @nodes.filter (n) =>
      return n.x? and n.y? and (if n.floor is 'T' then 0 else parseInt(n.floor)) is floor

  get_rooms_from_node: (node_id) ->
    results = @links.filter((l) -> l.source is node_id).map (l) -> l.target

    return @nodes.filter (n) -> n.id in results

  get_nodes_at_floor: (floor) ->
    # FIXME Indirect nodes are not returned
    return @nodes.filter (n) => n.floor is floor

  get_in_nodes: (node) ->
    results = @links.filter((l) -> l.type is 'in' and l.source is node.id).map (l) -> l.target

    return @nodes.filter (n) -> n.id in results

  get_points_from_node: (node) ->
    if node?
      if node.x? and node.y?
        return [{x: node.x, y: node.y, z: @floor_to_z(node.floor), node: node}]
      else if node.centroid?
        return [{x: node.centroid.x, y: node.centroid.y, z: @floor_to_z(node.floor), node: node}]
      else
        in_nodes = @get_in_nodes node
        return in_nodes.map (n) -> {x: n.centroid.x, y: n.centroid.y, node: node}
    else
      return []

  get_nodes_from_room: (room_id) ->
    node_ids = @links.filter((l) -> l.target is room_id).map (l) -> l.source

    return @nodes.filter (n) -> n.id in node_ids

  get_room_centroid: (room) ->
    return @rooms[room.label]
