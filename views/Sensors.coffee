observer class Sensors extends View

  constructor: (conf) ->
    super(conf)
    @init()

    @sensors = conf.sensors
    @weather_data = conf.weather_data

    @listen_to @sensors, 'change', () => 
      sensors = @sensors.get_sensors()
      weather_data = @weather_data.get_weather_data()
      if sensors isnt null
        @d3el.insert 'div'
          .text 'Room Sensors'
          .attrs
            class: 'label'
        @sensors_div = @d3el.append 'div'
          .attrs
            class: 'sensors'
        
        @redraw(sensors,weather_data)

    @listen_to @weather_data, 'change', () => 
      sensors = @sensors.get_sensors()
      if sensors isnt null
        weather_data = @weather_data.get_weather_data()
        @redraw(sensors,weather_data)



  redraw: (data,weather_data) =>
    
    values_sensors = {'Humidity': '%', 'Noise': 'db', 'Occupancy': '', 'PeoplePresence': '', 'SocketPower': 'kW', 'LightPower': 'kW', 'Temperature': '°'}
    icons = {'Humidity': 'tint', 'Noise': 'volume-up', 'Occupancy': 'users', 'PeoplePresence': 'users', 'SocketPower': 'plug', 'LightPower': 'lightbulb-o', 'Temperature': 'thermometer-three-quarters'}


    sensors = @sensors_div.selectAll '.sensor'
      .data data, (d,i) -> d

    enter_sensors = sensors.enter().append 'div'
      .html (d,i) ->
        switch d.MonitoredFeature
          when 'Temperature'
            "<div class='sensor_icon'><i class='fa fa-2x fa-#{icons[d.MonitoredFeature]}'><span>#{if data[(i-1)] and data[(i-1)].MonitoredFeature is d.MonitoredFeature then 2 else if data[(i+1)] and data[(i+1)].MonitoredFeature is d.MonitoredFeature then 1 else ''}</span></i></div><div class='sensor_info'><div class='sensor_type'>#{d.MonitoredFeature}</div><div class='sensor_value'>#{d.value}#{values_sensors[d.MonitoredFeature]}<span class='difference'> (+#{parseFloat(d.value)-parseFloat(weather_data.temp_c)}°)</span></div></div>"
          when 'Humidity'
            "<div class='sensor_icon'><i class='fa fa-2x fa-#{icons[d.MonitoredFeature]}'><span>#{if data[(i-1)] and data[(i-1)].MonitoredFeature is d.MonitoredFeature then 2 else if data[(i+1)] and data[(i+1)].MonitoredFeature is d.MonitoredFeature then 1 else ''}</span></i></div><div class='sensor_info'><div class='sensor_type'>#{d.MonitoredFeature}</div><div class='sensor_value'>#{d.value}#{values_sensors[d.MonitoredFeature]}<span class='difference'> (#{parseInt(d.value)-parseInt(weather_data.relative_humidity)}%)</span></div></div>"
          else
            "<div class='sensor_icon'><i class='fa fa-2x fa-#{icons[d.MonitoredFeature]}'><span>#{if data[(i-1)] and data[(i-1)].MonitoredFeature is d.MonitoredFeature then 2 else if data[(i+1)] and data[(i+1)].MonitoredFeature is d.MonitoredFeature then 1 else ''}</span></i></div><div class='sensor_info'><div class='sensor_type'>#{d.MonitoredFeature}</div><div class='sensor_value'>#{d.value}#{values_sensors[d.MonitoredFeature]}</div></div>"
      .attrs
        class: 'sensor'
      .on 'click', (d) -> 
        d3.selectAll('.sensor').classed('active', false)
        d3.select(this).classed('active', true)   

    all_sensors = enter_sensors.merge sensors

    all_sensors
      .html (d,i) ->
        switch d.MonitoredFeature
          when 'Temperature'
            "<div class='sensor_icon'><i class='fa fa-2x fa-#{icons[d.MonitoredFeature]}'><span>#{if data[(i-1)] and data[(i-1)].MonitoredFeature is d.MonitoredFeature then 2 else if data[(i+1)] and data[(i+1)].MonitoredFeature is d.MonitoredFeature then 1 else ''}</span></i></div><div class='sensor_info'><div class='sensor_type'>#{d.MonitoredFeature}</div><div class='sensor_value'>#{d.value}#{values_sensors[d.MonitoredFeature]}<span class='difference'>(+#{parseFloat(d.value)-parseFloat(weather_data.temp_c)}°)</span></div></div>"
          when 'Humidity'
            "<div class='sensor_icon'><i class='fa fa-2x fa-#{icons[d.MonitoredFeature]}'><span>#{if data[(i-1)] and data[(i-1)].MonitoredFeature is d.MonitoredFeature then 2 else if data[(i+1)] and data[(i+1)].MonitoredFeature is d.MonitoredFeature then 1 else ''}</span></i></div><div class='sensor_info'><div class='sensor_type'>#{d.MonitoredFeature}</div><div class='sensor_value'>#{d.value}#{values_sensors[d.MonitoredFeature]}<span class='difference'>(#{parseInt(d.value)-parseInt(weather_data.relative_humidity)}%)</span></div></div>"
          else
            "<div class='sensor_icon'><i class='fa fa-2x fa-#{icons[d.MonitoredFeature]}'><span>#{if data[(i-1)] and data[(i-1)].MonitoredFeature is d.MonitoredFeature then 2 else if data[(i+1)] and data[(i+1)].MonitoredFeature is d.MonitoredFeature then 1 else ''}</span></i></div><div class='sensor_info'><div class='sensor_type'>#{d.MonitoredFeature}</div><div class='sensor_value'>#{d.value}#{values_sensors[d.MonitoredFeature]}</div></div>"

    sensors.exit().remove()

  destructor: () ->
    @stop_listening()