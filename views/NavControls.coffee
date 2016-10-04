observer observable class NavControls extends View
  constructor: (conf) ->
    super(conf)
    @init
      events: ['change']

    floors = @d3el.selectAll '.floor'
      .data conf.floors

    floors.enter().append 'div'
      .attrs
        class: 'floor'
      .on 'click', (d,i) =>
        @trigger 'change', i
      .text (d) -> d.label
