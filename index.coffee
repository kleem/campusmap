ready = (error, graph) ->
  new AppView
    parent: 'body'
    graph: graph

d3.queue()
  .defer d3.json, 'data/graph.json'
  .await ready
