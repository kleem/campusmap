class Graph
  constructor: (conf) ->

    @nodes = [{id: 1, label: 'Auditorium', img: 'img/auditorium.jpg', x: 10, y: 10},{id: 2, label: 'Mensa', img: 'img/mensa.jpg', homepage:'http://www.area.pi.cnr.it/index.php/mensa/', x: 100, y: 100},{id: 3, label: 'Biblioteca', img: 'img/biblioteca.jpg', homepage: 'http://library.isti.cnr.it/index.php/it/', x: 200, y: 50},{id: 4, label: 'C40', img: 'img/aula.jpg', x: 500, y: 300},{id: 5, label: 'A32', img: 'img/aula.jpg', x: 500, y: 100},{id: 6, label: 'B76', img: 'img/aula.jpg', x:20, y: 500},{id: 7, label: 'A29', img: 'img/aula.jpg', x: 500, y: 100},{id: 8, type:'person', img: 'img/andrea.marchetti.jpg', label: 'Andrea Marchetti', institute: 'IIT', room: 'B65b', email: 'andrea.marchetti@iit.cnr.it', phone: '+39 050 315 2649', homepage: 'http://www.iit.cnr.it/en/andrea.marchetti'}]

  search: (string) ->
    return @nodes.filter (n) -> n.label.toLowerCase().indexOf(string.toLowerCase()) is 0 and string isnt ''