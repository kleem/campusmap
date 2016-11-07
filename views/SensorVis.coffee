observer class SensorVis extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @data_sensor = conf.data_sensor
    
    @listen_to @data_sensor, 'change', () => 
      data = @data_sensor.get_data_sensor()
      if data isnt null
        @d3el.append 'div'
          .text 'Last Week Power Usage'
          .attrs
            class: 'label'

        @redraw(data)

  redraw: (data) ->
    
    days_name = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat','Sun']
    hours_name = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23']
    

    max_weight = d3.max data, (d) -> d.power

    # LAYOUT

    # try to fit this rectangle with the matrix
    matrix_w = 600
    matrix_h = 400

    days_n = days_name.length
    hours_n = hours_name.length

    cellsize = Math.min matrix_w/hours_n, matrix_h/days_n # beware! a is y and b is x!

    x = d3.scaleBand()
      .domain days_name
      .range [-cellsize*days_n/2, cellsize*days_n/2]
      .padding 0.02
    
    y = d3.scaleBand()
      .domain hours_name # beware! a is y and b is x!
      .range [-cellsize*hours_n/2, cellsize*hours_n/2] # centered in (0,0)
      .padding 0.02

    console.log x.bandwidth()

    weight2size = d3.scaleSqrt()
      .domain [0, max_weight]
      .range [0, (x.bandwidth())-1] # x.bw == y.bw

    # VIS

    svg = @d3el.append 'svg'
    width = svg.node().getBoundingClientRect().width
    height = svg.node().getBoundingClientRect().height

    # center the vis on (0,0)
    vis = svg.append 'g'
      .attrs
        transform: "translate(#{width/2},#{height/2})"
        
    hlines = vis.selectAll '.hline'
      .data hours_name, (d) -> d
      
    en_hlines = hlines.enter().append 'line'
      .attrs
        class: 'hline line'
        
    all_hlines = en_hlines.merge hlines

    all_hlines
      .attrs
        x1: x.range()[0]
        y1: (d,i) -> i*y.step() + y.range()[0]
        x2: x.range()[1]
        y2: (d,i) -> i*y.step() + y.range()[0]
        
    hlines.exit().remove()

    vis.append 'line'
      .attrs
        class: 'line'
        x1: x.range()[0]
        y1: y.range()[1]
        x2: x.range()[1]
        y2: y.range()[1]


    vlines = vis.selectAll '.vline'
      .data days_name, (d) -> d
      
    en_vlines = vlines.enter().append 'line'
      .attrs
        class: 'vline line'
        
    all_vlines = en_vlines.merge vlines

    all_vlines
      .attrs
        x1: (d,i) -> i*x.step() + x.range()[0]
        y1: y.range()[0]
        x2: (d,i) -> i*x.step() + x.range()[0]
        y2: y.range()[1]
        
    vlines.exit().remove()

    vis.append 'line'
      .attrs
        class: 'line'
        x1: x.range()[1]
        y1: y.range()[0]
        x2: x.range()[1]
        y2: y.range()[1]

    # draw cells
    cells = vis.selectAll '.cell'
      .data data, (d) -> "#{d.day}--#{d.hour}"
      
    en_cells = cells.enter().append 'g'
      .attrs
        class: 'cell'
        transform: (d) -> "translate(#{x(d.day) + x.bandwidth()/2 - weight2size(d.power)/2}, #{y(d.hour) + y.bandwidth()/2 - weight2size(d.power)/2})"
    
    inner_cells = en_cells.append 'rect'
      .attrs
        class: 'innerCells'
        width: (d) -> weight2size(d.power)
        height: (d) -> weight2size(d.power)

    outer_cells = en_cells.append 'rect'
      .attrs
        class: 'outerCells'
        width: weight2size(max_weight)
        height: weight2size(max_weight)
      .append 'title'
        .text (d) -> "#{d.power} Kw/h"

    all_cells = en_cells.merge cells

    all_cells
      .attrs
        width: (d) -> weight2size(d.power)
        height: (d) -> weight2size(d.power)
            
    cells.exit().remove()

    # draw cells titles


    # draw row labels
    a_labels = vis.selectAll '.day_label'
      .data hours_name
      
    en_a_labels = a_labels.enter().append 'text'
      .attrs
        class: 'day_label'
        
    all_a_labels = en_a_labels.merge a_labels

    all_a_labels
      .text (d) -> d
      .attrs
        x: x.range()[0] - 8
        y: (d) -> y(d) + y.bandwidth()/2
      
    a_labels.exit().remove()

    # draw column labels
    b_labels = vis.selectAll '.hour_label'
      .data days_name
      
    en_b_labels = b_labels.enter().append 'text'
      .attrs
        class: 'hour_label'
        
    all_b_labels = en_b_labels.merge b_labels

    all_b_labels
      .text (d) -> d
      .attrs
        x: (d) -> x(d) + x.bandwidth()/2
        y: y.range()[0] - 8
      
    b_labels.exit().remove()
  


  destructor: () ->
    @stop_listening()
    