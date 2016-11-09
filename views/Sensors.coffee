observer class Sensors extends View

  constructor: (conf) ->
    super(conf)
    @init()

    @sensors = conf.sensors
    
    @listen_to @sensors, 'change', () => 
      sensors = @sensors.get_sensors()
      if sensors isnt null
        @d3el.append 'div'
          .text 'Room Sensors'
          .attrs
            class: 'label'

        @redraw(sensors)

  redraw: (data) ->
    
    values_sensors = {'Humidity': '%', 'Noise': 'db', 'Occupancy': '', 'PeoplePresence': '', 'SocketPower': 'kW', 'LightPower': 'kW', 'Temperature': '°'}
    icons = {'Humidity': 'tint', 'Noise': 'volume-up', 'Occupancy': 'users', 'PeoplePresence': 'users', 'SocketPower': 'plug', 'LightPower': 'lightbulb-o', 'Temperature': 'thermometer-three-quarters'}

    sensors_div = @d3el.append 'div'
      .attrs
        class: 'sensors'

    nested_data = d3.nest()
      .key (d) -> d.MonitoredFeature
      .entries data

    console.log nested_data

    sensors = sensors_div.selectAll '.sensor'
      .data data

    self = this
    enter_sensors = sensors.enter().append 'div'
      .html (d,i) -> 
        "<div class='sensor_icon'><i class='fa fa-2x fa-#{icons[d.MonitoredFeature]}'><span>#{if data[(i-1)] and data[(i-1)].MonitoredFeature is d.MonitoredFeature then 2 else if data[(i+1)] and data[(i+1)].MonitoredFeature is d.MonitoredFeature then 1 else ''}</span></i></div><div class='sensor_info'><div class='sensor_type'>#{d.MonitoredFeature}</div><div class='sensor_value'>#{d.value}#{values_sensors[d.MonitoredFeature]}</div></div>"
      .attrs
        class: 'sensor'
      .on 'click', (d) -> 
        d3.selectAll('.sensor').classed('active', false)
        d3.select(this).classed('active', true)   