observable class RoomEvents
  constructor: (conf) ->
    @init
      events: ['change']

    @room = conf.room

    @poll()
    @timer = setInterval ( () => @poll() ), 60000 # check every minute

  destructor: () ->
    clearInterval @timer

  poll: () ->
    console.debug 'RoomEvents polling'
    d3.json "data/scraping/aula.php?aula=\"#{@room}\"", (events) =>
      @events = events
      
      @trigger 'change'

  get_events: () -> @events
