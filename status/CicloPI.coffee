observable class CicloPI
  constructor: (conf) ->
    @init
      events: ['change']

    @poll()
    @timer = setInterval ( () => @poll() ), 1000 # check every minute

  destructor: () ->
    clearInterval @timer

  poll: () ->
    console.debug 'CicloPI polling'
    d3.json 'data/scraping/ciclopi.php', (result) =>
      @available_bicycles = parseInt(result.split(',')[0])
      @available_parkings = parseInt(result.split(',')[1])
      @spots = Array(@available_bicycles).fill(true).concat(Array(@available_parkings).fill(false))

      @trigger 'change'

  get_spots: () -> @spots
  get_available_bicycles: () -> @available_bicycles
  get_available_parkings: () -> @available_parkings
