class Graph
  constructor: (conf) ->
    @nodes = conf.nodes
    @links = conf.links

    # create indexes
    @nodes_index = {}
    @nodes_label_index = {} # FIXME this is temporary
    @nodes.forEach (d) =>
      @nodes_index[d.id] = d
      @nodes_label_index[d.label] = d # FIXME this is temporary
      d.incoming = []
      d.outgoing = []

    @links.forEach (d) =>
      d.source = @nodes_index[d.source]
      d.target = @nodes_index[d.target]
      d.source.outgoing.push d
      d.target.incoming.push d

    # merge rooms into the graph nodes
    # FIXME this is temporary
    conf.rooms.forEach (r) =>
      if r.label not of @nodes_label_index
        console.warn "No node found for room label #{r.label}"
      else
        console.debug "Found node for room #{r.label}"
        @nodes_label_index[r.label].sketchup_id = r.id

    # reindex according to the sketchup ID
    # FIXME this is temporary
    @nodes_sketchup_index = {}
    @nodes.forEach (d) =>
      @nodes_sketchup_index[d.sketchup_id] = d

    # merge centroids into the graph nodes
    # FIXME this is temporary
    conf.centroids.forEach (c) =>
      if c.id not of @nodes_sketchup_index
        console.warn "No node found for centroid ID #{c.id}"
      else
        console.debug "Found node for centroid #{c.id}"
        @nodes_sketchup_index[c.id].centroid = {x: +c.x, y: +c.y, z: +c.z}

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

  get_nodes_at_floor: (floor) ->
    return @nodes.filter (n) => n.floor is floor

  query: (node, predicate, direction) ->
    direction = if direction? then direction else 'outgoing'

    return node[direction].filter((l) -> l.type is predicate).map (l) -> switch direction
        when 'incoming' then l.source
        when 'outgoing' then l.target

  get_points_from_node: (node) ->
    if node?
      if node.x? and node.y?
        return [{x: node.x, y: node.y, z: @floor_to_z(node.floor), floor: node.floor, node: node}]
      else if node.centroid?
        return [{x: node.centroid.x, y: node.centroid.y, z: @floor_to_z(node.floor), floor: node.floor, node: node}]
      else
        # only takes into account direct 'in'
        points = []
        @query(node, 'in').forEach (n) =>
          if n.x? and n.y?
            points.push {x: n.x, y: n.y, z: @floor_to_z(n.floor), floor: n.floor, node: node}
          else if n.centroid?
            points.push {x: n.centroid.x, y: n.centroid.y, z: @floor_to_z(n.floor), floor: n.floor, node: node}
          # else do nothing
        return points
    else
      return []

  get_nodes_from_room: (room_id) ->
    node_ids = @links.filter((l) -> l.target is room_id).map (l) -> l.source

    return @nodes.filter (n) -> n.id in node_ids

  get_room_centroid: (room) ->
    return @rooms[room.label]
