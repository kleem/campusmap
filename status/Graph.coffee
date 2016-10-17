class Graph
  constructor: (conf) ->

    @nodes = [{id: 1, label: 'Auditorium', img: 'img/auditorium.jpg', x: 10, y: 10},{id: 2, label: 'Mensa', img: 'img/mensa.jpg', x: 100, y: 100},{id: 3, label: 'Biblioteca', img: 'img/biblioteca.jpg', x: 200, y: 50},{id: 4, label: 'C40', img: 'img/aula.jpg', x: 500, y: 300},{id: 5, label: 'A32', img: 'img/aula.jpg', x: 500, y: 100},{id: 6, label: 'B76', img: 'img/aula.jpg', x:20, y: 500},{id: 7, label: 'A29', img: 'img/aula.jpg', x: 500, y: 100}]

  search: (string) ->
    return @nodes.filter (n) -> n.label.toLowerCase().indexOf(string.toLowerCase()) > -1 and string isnt ''