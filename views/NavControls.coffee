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
        title: (d) -> d.label 
      .on 'click', (d) => @camera.set_current_floor d
      # Roof icon or id string
      .html (d) => if @camera.is_last_floor(d) then '<svg><path transform="translate(-140,-412.5)" d="m 160.36939,426.37082 c -0.17587,3e-5 -0.37993,0.002 -0.61448,0.002 -1.3474,0 -1.51053,0.0146 -1.62485,0.14087 -0.10898,0.12042 -0.13027,0.4069 -0.14815,2.00131 l -0.0219,1.86044 -0.31817,0.0243 -0.3206,0.0219 -0.0389,-0.55376 c -0.0639,-0.89296 0.25288,-0.81391 -3.98077,-1.00552 -3.51395,-0.15903 -3.65637,-0.15879 -3.82775,-0.0243 -0.31034,0.24356 -7.97531,11.46217 -8.01011,11.72371 -0.0411,0.30931 0.0647,0.39314 0.94237,0.74563 0.76606,0.30765 1.03916,0.35302 1.22653,0.20159 0.0661,-0.0534 1.548,-2.23059 3.29099,-4.83813 1.743,-2.60753 3.18162,-4.75587 3.1987,-4.77497 0.0681,-0.0762 0.52061,0.51747 3.68203,4.85269 1.808,2.4793 3.35768,4.58651 3.44401,4.68269 l 0.15544,0.17487 7.86195,0 c 6.30852,0 7.88757,-0.0188 7.99796,-0.0996 0.32849,-0.24019 0.21828,-0.41048 -4.02934,-6.27839 -2.26297,-3.12621 -4.18656,-5.72992 -4.27465,-5.78535 -0.10449,-0.0657 -0.70579,-0.12739 -1.73171,-0.17973 -0.86485,-0.0441 -1.60806,-0.10426 -1.65157,-0.13115 -0.0481,-0.0297 -0.0802,-0.51275 -0.0802,-1.23139 0,-1.44117 0.10419,-1.53035 -1.12696,-1.53013 z"/></svg>' else d.id

    enter_floors.merge(floors)
      .classed 'under', (d) => d.i < @camera.get_current_floor().i
      .classed 'selected', (d) => d is @camera.get_current_floor()

    floors.exit().remove()
