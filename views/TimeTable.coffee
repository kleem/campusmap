observer class TimeTable extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @timetable = conf.timetable

    @d3el.append 'div'
      .text 'TimeTable'
      .attrs
        class: 'label'

    @tt = @d3el.append 'table'
      
    th_tr = @tt.append 'tr'
      .html '<th>Time</th><th>Route</th><th>Bus Name</th>'

    @listen_to @timetable, 'change', () => @redraw()

  redraw: () ->
    data = @timetable.get_timetable()
      .filter (d) -> 
        d.date is "#{Date.today().getFullYear()}#{Date.today().getMonth()+1}#{Date.today().getDate()}"
       
    time_stops = @tt.selectAll '.time_stop'
      .data data[0].timetable.filter (d,i) ->
        new Date() < new Date(Date.today().getFullYear(),Date.today().getMonth(),Date.today().getDate(),d.time.split(':')[0],d.time.split(':')[1])
  
    en_time_stops = time_stops.enter().append 'tr'
      .attrs
        class: 'time_stops'

    all_time_stops = en_time_stops.merge time_stops

    all_time_stops
      .html (d,i) -> 
        "<td class='time'>#{d.time}</td><td class='end_station'>#{d.end_station}</td><td class='bus_name'>#{d.bus_name}</td>"

    time_stops.exit().remove()

  destructor: () ->
    @stop_listening()
    