observer class NavControls extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @camera = conf.camera

    floors = @d3el.selectAll '.floor'
      .data conf.floors

    floors.enter().insert('button', 'button:first-child')
      .attrs
        class: 'floor'
      .on 'click', (d,i) => @camera.set_floor i
      .text (d) -> d.label

    @listen_to @camera, 'change', () => @floor_change()

  # Highlights the selected button
  floor_change: () ->
    d3.selectAll('.floor').classed('selected', false)
    d3.selectAll('.floor').filter((d,i) => Math.abs(i-@camera.get_n_floors()) is @camera.get_floor()).classed('selected', true)
