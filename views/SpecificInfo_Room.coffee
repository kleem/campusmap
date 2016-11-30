# FIXME maybe the correct name is 'office'?
class SpecificInfo_Room extends SpecificInfo
  constructor: (conf) ->
    super(conf)

    people = conf.graph.query(conf.node, 'in', 'incoming').filter (d) -> d.type is 'person'
    @draw_section people, 'Ufficio di'
