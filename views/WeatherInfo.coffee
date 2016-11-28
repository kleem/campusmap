observer class WeatherInfo extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @weather_data = conf.weather_data

    @d3el.append 'div'
      .text 'Weather'
      .attrs
        class: 'label'

    @listen_to @weather_data, 'change', () => @redraw()

  redraw: () ->
    data = @weather_data.get_weather_data()

    temperature = @d3el.selectAll '.temperature'
      .data [data.temp_c]

    temperature.enter().append 'div'
      .attrs
        class: 'temperature'
      .html (d) -> "<i class='fa fa-thermometer-half'></i> #{d}°"

    temperature
      .html (d) -> "<i class='fa fa-thermometer-half'></i> #{d}°"

    temperature.exit().remove()

    humidity = @d3el.selectAll '.humidity'
      .data [data.relative_humidity]

    humidity.enter().append 'div'
      .attrs
        class: 'humidity'
      .html (d) -> "<i class='fa fa-tint'></i> #{d}°"

    humidity
      .html (d) -> "<i class='fa fa-tint'></i> #{d}°"

    humidity.exit().remove()

    wind = @d3el.selectAll '.wind'
      .data [(parseInt(data.wind_kt)*1.86)]

    wind.enter().append 'div'
      .attrs
        class: 'wind'
      .html (d) -> "Wind: #{d3.format(".1f")(d)} km/h"

    wind
      .html (d) -> "Wind: #{d3.format(".1f")(d)} km/h"

    wind.exit().remove()



  destructor: () ->
    @stop_listening()
    