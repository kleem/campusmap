observer class InfoBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @graph = conf.graph
    @selection = conf.selection
    @weather_data = conf.weather_data

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

    # round icon/thumbnail
    if @d3el.datum().thumbnail? and @d3el.datum().thumbnail isnt ''
      profile.append 'div'
        .attrs
          class: 'img'
        .styles
          'background-image': (d) -> "url(#{d.thumbnail})"
    else if @d3el.datum().icon?
      profile.append 'div'
        .attrs
          class: 'img'
      .html (d) -> "<i class='icon fa fa-fw #{d.icon}'></i>"

    # label
    profile_info = profile.append 'div'
      .attrs
        class: 'info'

    profile_info.append 'div'
      .attrs
        class: 'label'
      .text (d) -> d.label

    if @d3el.datum().type is 'person'
      profile_info.append 'div'
        .attrs
          class: 'position'
        .text (d) ->
          if d.position is ''
            "#{d.institute}"
          else if not(d.institute?)
            "#{d.position}"
          else "#{d.position}, #{d.institute}"

    # directions
    #directions = profile.append 'div'
    #  .attrs
    #    class: 'directions'

    #directions.append 'div'
    #  .attrs
    #    class: 'direction to'
    #  .html '<i class="fa fa-arrow-circle-left" aria-hidden="true"></i><div>To</div>'

    #directions.append 'div'
    #  .attrs
    #    class: 'direction from'
    #  .html '<i class="fa fa-arrow-circle-right" aria-hidden="true"></i><div>From</div>'

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
        .attrs
          class: 'room'
        .on 'click', (d) => @selection.set @graph.query(d, 'in')[0]
        .text (d) -> "room #{d.room}"

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

    # mobile
    if @d3el.datum().mobile?
      mobile = info.append 'div'
        .attrs
          class: 'info'
      mobile.append 'div'
        .html '<i class="fa fa-mobile" aria-hidden="true"></i> '
      mobile.append 'div'
        .append 'a'
          .attrs
            href: (d) -> "tel:#{d.mobile}"
          .text (d) -> d.mobile

    # email
    if @d3el.datum().email?

      emails = info.selectAll '.info_email'
        .data (if typeof @d3el.datum().email is 'string' then [@d3el.datum().email] else @d3el.datum().email)

      email = emails.enter().append 'div'
        .attrs
          class: 'info info_email'

      email.append 'div'
        .html '<i class="fa fa-envelope-o" aria-hidden="true"></i> '

      email.append 'div'
        .append 'a'
          .attrs
            href: (d) -> "mailto:#{d}"
          .text (d) -> d

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

    # room
    if @d3el.datum().type is 'room'
      # floor
      floor = info.append 'div'
        .attrs
          class: 'info'
      floor.append 'div'
        .html '<i class="fa fa-map-marker" aria-hidden="true"></i> '
      floor.append 'div'
        .text (d) -> "piano #{d.floor}"

      # gateway
      if @d3el.datum().gateway?
        gateway = info.append 'div'
          .attrs
            class: 'info'
        gateway.append 'div'
          .html '<i class="fa fa-sign-in" aria-hidden="true"></i> '
        gateway.append 'div'
          .text (d) -> "ingresso #{d.gateway}"

    #address
    if @d3el.datum().address?
      # floor
      address = info.append 'div'
        .attrs
          class: 'info'
      address.append 'div'
        .html '<i class="fa fa-map-marker" aria-hidden="true"></i> '
      address.append 'div'
        .text (d) -> "#{d.address}"

    # room capacity
    if @d3el.datum().capacity?
      capacity = info.append 'div'
        .attrs
          class: 'info'
      capacity.append 'div'
        .html '<i class="fa fa-group" aria-hidden="true"></i> '
      capacity.append 'div'
        .text (d) -> "Capacità #{d.capacity} persone"

    # printer ip
    if @d3el.datum().ip?
      ip = info.append 'div'
        .attrs
          class: 'info'
      ip.append 'div'
        .html '<i class="fa fa-share-alt" aria-hidden="true"></i> '
      ip.append 'div'
        .text (d) -> "Indirizzo IP #{d.ip}"

    # timetables
    if @d3el.datum().timetables?
      timetables = info.append 'div'
        .attrs
          class: 'info'
      timetables.append 'div'
        .html '<i class="fa fa-clock-o" aria-hidden="true"></i> '
      timetables.append 'div'
        .text (d) -> "#{d.timetables}"

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
        .text 'Disponibilità'

      icon_ciclopi_div = ciclopi.append 'div'
        .attrs
          class: 'icon_ciclopi_div'

      @spin = icon_ciclopi_div.append 'div'
        .html '<i class="fa fa-spinner fa-spin"></i>'

      spec_info = ciclopi.append 'p'
        .attrs
          class: 'text_ciclopi'

      # listen to ciclopi service
      if not @ciclopi?
        @ciclopi = new CicloPI
        @ciclopi_binding = @ciclopi.on 'change', () =>
          @spin.remove()
          icon_ciclopi = icon_ciclopi_div.selectAll '.ciclopi_parking'
            .data @ciclopi.get_spots()

          icon_ciclopi.enter().append 'div'
            .attrs
              class: 'ciclopi_parking'
            .append 'i'

          icon_ciclopi.select 'i'
            .attrs
              class: (d) ->
                if d is true
                  'fa fa-bicycle fa-rotate-270'
                else if d is null
                  'fa fa-warning'
              title: (d) ->
                if d is true
                  'biciclette disponibili'
                else if d is null
                  'stalli inattivi'
                else
                  'stalli attivi'

          available_bicycles = @ciclopi.get_available_bicycles()
          available_parkings = @ciclopi.get_available_parkings()
          inactive_parkings = @ciclopi.get_inactive_parkings()

          spec_info
            .html () ->
              bicycles = 'bicycles'
              spots = 'spots'
              if available_bicycles is 1
                bicycles = 'bicycle'
              if available_parkings is 1
                spots = 'spot'
              "#{available_bicycles} #{bicycles} e #{available_parkings} #{spots} disponibili e #{inactive_parkings} #{spots} inattivi"
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

    if @d3el.datum().type is 'bus'
      @bt = new BusTimetable
        bus_stop: @d3el.datum().label
      @tt = new TimeTable
        parent: spec_info
        timetable: @bt
    else
      if @bt?
        delete @bt
      if @tt?
        @tt.destructor()
        delete @tt

    if @d3el.datum().type is 'building'
      new SpecificInfo_Building
        graph: @graph
        node: @d3el.datum()
        container: spec_info
        selection: @selection

    if @d3el.datum().type is 'institute'
      new SpecificInfo_Institute
        graph: @graph
        node: @d3el.datum()
        container: spec_info
        selection: @selection

    if @d3el.datum().type is 'research_unit'
      new SpecificInfo_ResearchUnit
        graph: @graph
        node: @d3el.datum()
        container: spec_info
        selection: @selection

    if @d3el.datum().type is 'person'
      new SpecificInfo_Person
        graph: @graph
        node: @d3el.datum()
        container: spec_info
        selection: @selection

    if @d3el.datum().type is 'room'
      new SpecificInfo_Room
        graph: @graph
        node: @d3el.datum()
        container: spec_info
        selection: @selection

      ### Add data sensor of the room (punchcard)
      ###
      ###
      @ds = new DataSensors
        room_name: @d3el.datum().label
      @sv = new SensorVis
        parent: spec_info
        data_sensor: @ds
      ###

      ### Show sensors of the room
      ###
      @rs = new RoomSensors
        room_name: @d3el.datum().label
      @s = new Sensors
        parent: spec_info
        sensors: @rs
        weather_data: @weather_data
    else
      ###
      if @ds?
        delete @ds
      if @sv?
        @sv.destructor()
        delete @sv
      ###

      if @rs?
        delete @rs
      if @s?
        @s.destructor()
        delete @s
