class SpecificInfo_Building extends SpecificInfo
  constructor: (conf) ->
    super(conf)

    managers = conf.graph.query(conf.node, 'manager_of', 'incoming').filter (d) -> d.type is 'person'
    @draw_section managers, 'Responsabili'

    institutes = conf.graph.query(conf.node, 'located_in', 'incoming').filter (d) -> d.type is 'institute'
    @draw_section institutes, 'Istituti'
