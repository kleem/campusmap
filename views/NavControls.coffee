observer class NavControls extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @camera = conf.camera

    @listen_to @camera, 'change_floor', () => @redraw()

  # Highlights the selected button
  redraw: () ->
    floors = @d3el.selectAll '.floor'
      .data @camera.get_floors(), (d) -> d.id

    enter_floors = floors.enter().insert('button', 'button:first-child')
      .attrs
        class: 'floor'
      .on 'click', (d) => @camera.set_current_floor d
      .text (d) -> d.id

    enter_floors.merge(floors)
      .classed 'under', (d) => d.i < @camera.get_current_floor().i
      .classed 'selected', (d) => d is @camera.get_current_floor()

    floors.exit().remove()
