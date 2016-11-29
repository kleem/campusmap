observer class WeatherInfo extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @weather_data = conf.weather_data

    @listen_to @weather_data, 'change', () => @redraw()

  to_it: (value) ->
    return value.toLowerCase().replace('north', 'N').replace('south', 'S').replace('west', 'O').replace('east', 'E')

  to_km_per_h: (value) ->
    return @round_first_decimal(value * 1.60934)

  to_mm: (value) ->
    return value * 25.4

  to_celsius: (value) ->
    return @round_first_decimal((value-32)*(5/9))

  round_first_decimal: (value) ->
    return Math.round(value * 10) / 10

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
      .html "<div><img style='width: 18px' src='img/drop.svg'></div><div>#{data.relative_humidity}%</div>"
      .attrs
        title: 'Umidità'

    other_info.append 'div'
      .html "<div><img style='width: 18px' src='img/rain.svg'></div><div>#{@round_first_decimal(@to_mm(data.davis_current_observation.rain_day_in))} mm</div>"
      .attrs
        title: 'Precipitazioni'

    other_info.append 'div'
      .html "<div><img style='width: 18px' src='img/wind.svg'></div><div>#{@to_km_per_h(data.wind_mph)} km/h</div>"
      .attrs
        title: 'Vento'

  destructor: () ->
    @stop_listening()
    