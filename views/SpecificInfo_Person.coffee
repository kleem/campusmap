class SpecificInfo_Person extends SpecificInfo
  constructor: (conf) ->
    super(conf)

    rooms = conf.graph.query(conf.node, 'in', 'outgoing').filter (d) -> d.type is 'room'
    @draw_section rooms, 'Ufficio'

    groups = conf.graph.query(conf.node, 'part_of', 'outgoing').filter (d) -> d.type is 'research_unit'
    @draw_section groups, 'Unità di ricerca'
