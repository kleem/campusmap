observer class InfoBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @graph = conf.graph
    @selection = conf.selection

    @listen_to @selection, 'change', () =>
      s = @selection.get()

      @d3el.datum s
      @d3el.html ''

      if s is null
        @d3el.classed 'hidden', true
        return

      @d3el.classed 'hidden', false

      @draw_node()

  draw_node: () ->

    # img
    @d3el.append 'img'
      .attrs
        class: 'top_img'
        src: (d) -> if d.img? then d.img else 'img/office.png'

    ### node profile
    ###
    profile = @d3el.append 'div'
      .attrs
        class: 'profile'

    # round icon
    if @d3el.datum().icon? and @d3el.datum().icon isnt ''
      profile.append 'div'
        .attrs
          class: 'img'
        .styles
          'background-image': (d) -> "url(#{d.icon})"

    # label
    profile.append 'div'
      .attrs
        class: 'label'
      .text (d) -> d.label

    # directions
    directions = profile.append 'div'
      .attrs
        class: 'directions'

    directions.append 'div'
      .attrs
        class: 'direction to'
      .html '<i class="fa fa-arrow-circle-left" aria-hidden="true"></i><div>To</div>'

    directions.append 'div'
      .attrs
        class: 'direction from'
      .html '<i class="fa fa-arrow-circle-right" aria-hidden="true"></i><div>From</div>'

    ### additional information
    ###
    info = @d3el.append 'div'
      .attrs
        class: 'information'

    # place
    if @d3el.datum().institute and @d3el.datum().room?
      place = info.append 'div'
        .attrs
          class: 'info'
      place.append 'div'
        .html '<i class="fa fa-map-marker" aria-hidden="true"></i> '
      place.append 'div'
        .text (d) -> "#{d.institute}, room #{d.room}"

    # phone
    if @d3el.datum().phone?
      phone = info.append 'div'
        .attrs
          class: 'info'
      phone.append 'div'
        .html '<i class="fa fa-phone" aria-hidden="true"></i> '
      phone.append 'div'
        .append 'a'
          .attrs
            href: (d) -> "tel:#{d.phone}"
          .text (d) -> d.phone

    # email
    if @d3el.datum().email?
      email = info.append 'div'
        .attrs
          class: 'info'
      email.append 'div'
        .html '<i class="fa fa-envelope-o" aria-hidden="true"></i> '
      email.append 'div'
        .append 'a'
          .attrs
            href: (d) -> "mailto:#{d.email}"
          .text (d) -> d.email

    # homepage
    if @d3el.datum().homepage?
      homepage = info.append 'div'
        .attrs
          class: 'info'
      homepage.append 'div'
        .html '<i class="fa fa-globe" aria-hidden="true"></i> '
      homepage.append 'div'
        .append 'a'
          .attrs
            href: (d) -> d.homepage
            target: '_blank'
          .text (d) -> d.homepage.replace /http[s]?:\/\//, ''

    ### specific information
    ###
    spec_info = @d3el.append 'div'
      .attrs
        class: 'specific_information'

    # ciclopi
    if @d3el.datum().label is 'cicloPI'

      ciclopi = spec_info.append 'div'
        .attrs
          class: 'ciclopi'

      ciclopi.append 'div'
        .attrs
          class: 'label'
        .text 'Availability'

      icon_ciclopi_div = ciclopi.append 'div'
        .attrs
          class: 'icon_ciclopi_div'

      spec_info = ciclopi.append 'p'
        .attrs
          class: 'text_ciclopi'

      # listen to ciclopi service
      if not @ciclopi?
        @ciclopi = new CicloPI
        @ciclopi_binding = @ciclopi.on 'change', () =>
          icon_ciclopi = icon_ciclopi_div.selectAll '.ciclopi_parking'
            .data @ciclopi.get_spots()

          icon_ciclopi.enter().append 'div'
            .attrs
              class: 'ciclopi_parking'
            .append 'i'

          icon_ciclopi.select 'i'
            .attrs
              class: (d) ->
                if d
                  'fa fa-bicycle fa-rotate-270'

          available_bicycles = @ciclopi.get_available_bicycles()
          available_parkings = @ciclopi.get_available_parkings()

          spec_info
            .html () ->
              bicycles = 'bicycles'
              spots = 'spots'
              if available_bicycles is 1
                bicycles = 'bicycle'
              if available_parkings is 1
                spots = 'spot'
              "#{available_bicycles} #{bicycles} and #{available_parkings} #{spots} available"
    else
      if @ciclopi?
        # stop listening
        @ciclopi.on @ciclopi_binding, null
        @ciclopi.destructor()
        delete @ciclopi

    # canteen
    menu_url = 'http://www.area.pi.cnr.it/images/'+Date.today().toString('MMMM')+'-'+Date.parse('lunedì').toString('dd')+'-'+Date.parse('venerdì').toString('dd')+'.png'
    if @d3el.datum().label is 'Canteen'
      spec_info
        .html "<div class='label'>Menu</div><a href='#{menu_url}'><img style='width:100%;filter:saturate(60%);' src='#{menu_url}'/></a>"

    # auditorium
    # FIXME need a better way to do this...
    if @d3el.datum().label is 'Auditorium'
      @re = new RoomEvents
        room: 'Auditorium'
      @ec = new EventsCalendar
        parent: spec_info
        events: @re
    else
      if @re?
        delete @re
      if @ec?
        @ec.destructor()
        delete @ec

    if @d3el.datum().label.search 'Bus Stop' > -1
      @bt = new BusTimetable
        bus_stop: @d3el.datum().label.split('Bus Stop ')[1]
      @tt = new TimeTable
        parent: spec_info
        timetable: @bt
    else
      if @bt?
        delete @bt
      if @tt?
        @tt.destructor()
        delete @tt