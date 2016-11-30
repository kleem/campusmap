class SpecificInfo_ResearchUnit extends SpecificInfo
  constructor: (conf) ->
    super(conf)

    institutes = conf.graph.query(conf.node, 'part_of', 'outgoing').filter (d) -> d.type is 'institute'
    @draw_section institutes, 'Istituto'

    people = conf.graph.query(conf.node, 'part_of', 'incoming').filter (d) -> d.type is 'person'
    @draw_section people, 'Membri'
