ready = (error, graph, rooms, centroids) ->
  new AppView
    parent: 'body'
    graph: graph
    rooms: rooms
    centroids: centroids

d3.queue()
  .defer d3.json, 'data/graph.json'
  .defer d3.csv, 'data/rooms.csv'
  .defer d3.csv, 'data/room_centroid.csv'
  .await ready
