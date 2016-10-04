class Graph
  constructor: (conf) ->

    @nodes = [{id: 1, label: 'pippo', x: 10, y: 10},{id: 2, label: 'paperino', x: 100, y: 100},{id: 3, label: 'paperoga', x: 200, y: 50},{id: 4, label: 'gastone', x: 500, y: 300},{id: 5, label: 'paperone', x: 500, y: 100},{id: 6, label: 'paperina', x:20, y: 500}]

  search: (string) ->
    results = []
    for i in @nodes
      if i.label.indexOf(string) >-1 and string isnt ''
        results.push(i)
    return results