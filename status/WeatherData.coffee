observable class WeatherData
  constructor: (conf) ->
    @init
      events: ['change']

    @poll()
    @timer = setInterval ( () => @poll() ), 5000 # check every 5 seconds

  destructor: () ->
    clearInterval @timer

  poll: () ->
    console.debug 'WeatherData polling'
    d3.json 'data/scraping/weather.php', (result) =>
      
      @weather_data = result

      @trigger 'change'

  get_weather_data: () -> @weather_data
  
