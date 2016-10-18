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

    ### profile img
    ###
    if @d3el.datum().img_profile?
      description.append 'div'
        .append 'img'
          .attrs
            class: 'profile_img'
            src: (d) -> d.img_profile
