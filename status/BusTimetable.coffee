observable class BusTimetable
  constructor: (conf) ->
    @init
      events: ['change']

    @bus_stop = conf.bus_stop

    @poll()

  poll: () ->
    d3.json "data/scraping/cpt/cpt.json", (timetable) =>
      @timetable = timetable.filter (d) =>
        console.log @bus_stop
        d.bus_stop_name is @bus_stop  

      console.log @timetable
      @timetable = @timetable[0].data
      console.log @timetable

      @trigger 'change'

  get_timetable: () -> @timetable
