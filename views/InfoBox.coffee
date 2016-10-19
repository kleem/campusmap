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
        src: (d) -> if d.img? then d.img else 'img/default.jpg'

    # description
    description = @d3el.append 'div'
      .attrs
        class: 'description'

    ### info
    ###
    info = description.append 'div'
    info.append 'div'
      .attrs
        class: 'label'
      .text (d) -> d.label

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

    ### icon
    ###
    if @d3el.datum().icon? and @d3el.datum().icon isnt ''
      description.append 'div'
        .attrs
          class: 'profile_img'
        .styles
          'background-image': (d) -> "url(#{d.icon})"


    ### ciclopi
    ###
    if @d3el.datum().label is 'cicloPI'
      d3.json 'data/scraping/ciclopi.php', (result) ->
        available_bicycles = parseInt(result.split(',')[0])
        available_parkings = parseInt(result.split(',')[1])
        data = Array(available_bicycles).fill(true).concat(Array(available_parkings).fill(false))
        
        ciclopi = info.append 'div'
          .attrs
            class: 'ciclopi'
        
        icon_ciclopi_div = ciclopi.append 'div'
          .attrs
            class: 'icon_ciclopi_div'

        icon_ciclopi = icon_ciclopi_div.selectAll '.ciclopi_parking'
          .data data

        icon_ciclopi.enter().append 'div'
          .attrs
            class: 'ciclopi_parking'
          .append 'i'
            .attrs
              class: (d) ->
                if d
                  'fa fa-bicycle fa-rotate-270'

        ciclopi.append 'p'
          .attrs
            class: 'text_ciclopi'
          .html () ->
            biciclette = 'biciclette'
            posti = 'posti'
            if available_bicycles is 1
              biciclette = 'bicicletta'
            if available_parkings is 1
              posti = 'posto'
            "#{available_bicycles} #{biciclette} e #{available_parkings} #{posti} disponibili"
