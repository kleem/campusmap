observable class BusTimetable
  constructor: (conf) ->
    @init
      events: ['change']

    @bus_stop = conf.bus_stop

    @poll()

  poll: () ->
    d3.json "data/scraping/cpt/cpt.json", (timetable) =>
      @timetable = timetable.filter (d) =>
        d.bus_stop_name is @bus_stop  

      @timetable = @timetable[0].data

      @trigger 'change'

  get_timetable: () -> @timetable
