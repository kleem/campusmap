observer class EventsCalendar extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @events = conf.events

    @d3el.append 'div'
      .text 'Events calendar'
      .attrs
        class: 'label'

    @cal = @d3el.append 'div'
      
    @spin = @cal.append 'div'
      .html '<i class="fa fa-spinner fa-spin"></i>'

    @listen_to @events, 'change', () => @redraw()

  redraw: () ->

    @spin.remove()

    data = @events.get_events()
      .filter (d) -> new Date(d.day) >= Date.today() # keep only present or future events

    # days

    days_data = d3.nest()
      .key (d) -> d.day
      .entries data

    days = @cal.selectAll '.day'
      .data days_data, (d) -> d.key

    en_days = days.enter().append 'div'
      .attrs
        class: 'day'

    en_number = en_days.append 'div'
      .attrs
        class: 'day_indicator'
      .classed 'current', (d) -> +(new Date(d.key)) == +(Date.today())

    en_number.append 'div'
      .text (d) -> new Date(d.key).toString('dd')
      .attrs
        class: 'day_number'


    en_number.append 'div'
      .text (d) -> new Date(d.key).toString('MMM')
      .attrs
        class: 'month_name'

    en_days.append 'div'
      .attrs
        class: 'events'

    all_days = en_days.merge(days)

    days.exit().remove()

    # events

    events = all_days.selectAll('.events').selectAll '.event'
      .data ((d) -> d.values), (d) -> d.label

    en_events = events.enter().append 'div'
      .attrs
        class: 'event'

    en_events.append 'span'
      .text (d) -> "#{d.from} - #{d.to}"
      .attrs
        class: 'time'

    en_events.append 'a'
      .text (d) -> d.label
      .attrs
        href: (d) -> d.link


    all_events = en_events.merge(events)

    all_events.classed 'current', (d) ->
      [start_h, start_m] = d.from.split(':').map (d) -> +d
      [end_h, end_m] = d.to.split(':').map (d) -> +d
      start = new Date(new Date(d.day).setHours(start_h)).setMinutes(start_m)
      end = new Date(new Date(d.day).setHours(end_h)).setMinutes(end_m)

      return start <= new Date() <= end

    events.exit().remove()
