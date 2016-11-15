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
      @available_bicycles = parseInt(result[0])
      @available_parkings = parseInt(result[1])
      @inactive_parkings = parseInt(result[2])
      @spots = Array(@available_bicycles).fill(true).concat(Array(@available_parkings).fill(false)).concat(Array(@inactive_parkings).fill(null))

      @trigger 'change'

  get_spots: () -> @spots
  get_available_bicycles: () -> @available_bicycles
  get_available_parkings: () -> @available_parkings
  get_inactive_parkings: () -> @inactive_parkings
