observer class WeatherInfo extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @weather_data = conf.weather_data

    @listen_to @weather_data, 'change', () => @redraw()

  to_it: (value) ->
    return value.toLowerCase().replace('north', 'N').replace('south', 'S').replace('west', 'O').replace('east', 'E')

  to_meters_per_second: (value) ->
    return @round_first_decimal(value * 0.44704)

  round_first_decimal: (value) ->
    return Math.round(value * 10) / 10

  to_celsius: (value) ->
    return @round_first_decimal((value-32)*(5/9))

  redraw: () ->
    data = @weather_data.get_weather_data()

    @d3el.text ''

    temperatures = @d3el.append 'div'
      .attrs
        class: 'temperature'

    temperatures.append 'div'
      .attrs
        class: 'current'
      .text "#{@to_celsius(data.temp_f)}°"

    min_max = temperatures.append 'div'
      .attrs
        class: 'min_max'    

    min_max.append 'div'
      .text "#{@to_celsius(data.davis_current_observation.temp_day_high_f)}°"

    min_max.append 'div'
      .text "#{@to_celsius(data.davis_current_observation.temp_day_low_f)}°"

    other_info = @d3el.append 'div'
      .attrs
        class: 'other_info'

    other_info.append 'div'
      .html "<div><img style='width: 18px' src='img/humidity.svg'></div><div>#{data.relative_humidity}%</div>"
      .attrs
        title: 'Umidità'

    other_info.append 'div'
      .html "<div><img style='width: 18px' src='img/drop.svg'></div><div>#{@round_first_decimal(data.davis_current_observation.rain_day_in)}%</div>"
      .attrs
        title: 'Precipitazioni'

    other_info.append 'div'
      .html "<div><img style='width: 18px' src='img/wind.svg'></div><div>#{@to_meters_per_second(data.wind_mph)} m/s</div>"
      .attrs
        title: 'Vento'

  destructor: () ->
    @stop_listening()
    