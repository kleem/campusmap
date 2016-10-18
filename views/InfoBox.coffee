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

      if s? and s.type is 'person'
        @draw_person()
      else
        @draw_place()

  draw_person: () ->
    # img
    @d3el.append 'img'
      .attrs
        class: 'top_img'
        src: 'img/person.jpg'

    # description
    description = @d3el.append 'div'
      .attrs
        class: 'description person'
    
    person_img = description.append 'div'
    person_info = description.append 'div'

    person_img.append 'img'
      .attrs
        class: 'profile_img'
        src: (d) -> d.img

    person_info.append 'div'
      .attrs
        class: 'label'
      .text (d) -> d.label

    # place
    place = person_info.append 'div'
    place.append 'span'
      .html '<i class="fa fa-map-marker" aria-hidden="true"></i> '
    place.append 'span'
      .text (d) -> "#{d.institute}, room #{d.room}"

    # phone
    phone = person_info.append 'div'
    phone.append 'span'
      .html '<i class="fa fa-phone" aria-hidden="true"></i> '
    phone.append 'a'
      .attrs
        href: (d) -> "tel:#{d.phone}"
        target: '_blank'
      .text (d) -> d.phone

    # email
    email = person_info.append 'div'
    email.append 'span'
      .html '<i class="fa fa-envelope-o" aria-hidden="true"></i> '
    email.append 'a'
      .attrs
        href: (d) -> "mailto:#{d.email}"
        target: '_blank'
      .text (d) -> d.email

    # homepage
    homepage = person_info.append 'div'
    homepage.append 'span'
      .html '<i class="fa fa-globe" aria-hidden="true"></i> '
    homepage.append 'a'
      .attrs
        href: (d) -> d.homepage
        target: '_blank'
      .text (d) -> d.homepage.replace /http[s]?:\/\//, ''

  draw_place: () ->
    # img
    @d3el.append 'img'
      .attrs
        class: 'top_img'
        src: (d) -> d.img

    # description
    description = @d3el.append 'div'
      .attrs
        class: 'description place'

    description.append 'div'
      .attrs
        class: 'label'
      .text (d) -> d.label

    # homepage
    if @d3el.datum().homepage?
      homepage = description.append 'div'
      homepage.append 'span'
        .html '<i class="fa fa-globe" aria-hidden="true"></i> '
      homepage.append 'a'
        .attrs
          href: (d) -> d.homepage
          target: '_blank'
        .text (d) -> d.homepage.replace /http[s]?:\/\//, ''