class SpecificInfo_Institute extends SpecificInfo
  constructor: (conf) ->
    super(conf)

    buildings = conf.graph.query(conf.node, 'located_in', 'outgoing').filter (d) -> d.type is 'building'
    @draw_section buildings, 'Sede'

    groups = conf.graph.query(conf.node, 'part_of', 'incoming').filter (d) -> d.type is 'research_unit'
    @draw_section groups, 'Unità di ricerca'
