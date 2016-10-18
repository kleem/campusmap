class Graph
  constructor: (conf) ->
    @nodes = [{id: 1, label: 'Auditorium', img: 'img/auditorium.jpg', x: 10, y: 10, floor: 0},{id: 2, label: 'Mensa', img: 'img/mensa.jpg', homepage:'http://www.area.pi.cnr.it/index.php/mensa/', x: 100, y: 100, floor: 0},{id: 3, label: 'Biblioteca', img: 'img/biblioteca.jpg', homepage: 'http://library.isti.cnr.it/index.php/it/', x: 200, y: 50, floor: 1},{id: 4, label: 'C40', img: 'img/aula.jpg', x: 500, y: 300, floor: 1},{id: 5, label: 'A32', img: 'img/aula.jpg', x: 500, y: 100, floor: 1},{id: 6, label: 'B76', img: 'img/aula.jpg', x:20, y: 500, floor: 1},{id: 7, label: 'A29', img: 'img/aula.jpg', x: 500, y: 100, floor: 2},{id: 8, type:'person', img_profile: 'img/andrea.marchetti.jpg', label: 'Andrea Marchetti', institute: 'IIT', room: 'B65b', email: 'andrea.marchetti@iit.cnr.it', phone: '+39 050 315 2649', homepage: 'http://www.iit.cnr.it/en/andrea.marchetti'},{id: 9, type:'person', img_profile: 'img/alessandro.prosperi.jpg', label: 'Alessandro Prosperi', institute: 'IIT', room: 'C25a', email: 'alessandro.prosperi@iit.cnr.it', phone: '+39 050 315 8261', homepage: 'http://www.iit.cnr.it/en/alessandro.prosperi'},{id:10, label: 'B65b', floor: 1}]

    # sources are nodes such as persons or printers while targets are rooms 
    @links = [{source: 8, target: 10}]

    @max_results = 5

  search: (string) ->
    return @nodes.filter((n) -> n.label.toLowerCase().indexOf(string.toLowerCase()) is 0 and string isnt '').slice(0, @max_results)

  get_rooms_from_node: (node_id) ->
    results = @links.filter((l) -> l.source is node_id).map (l) -> l.target

    return @nodes.filter (n) -> n.id in results