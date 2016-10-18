observer class InfoBox extends View
  constructor: (conf) ->
    super(conf)
    @init()
    
    @graph = conf.graph
    @selection = conf.selection

    @listen_to @selection, 'change', () =>
      s = @selection.get()

      if s? and s.type is 'person'
        @draw_person()
      else
        @draw_place()

  draw_top_image: (data) ->
    image = @d3el.selectAll '.top_img'
      .data data

    enter_image = image.enter().append 'img'

    enter_image.merge(image)
      .attrs
        class: 'top_img'
        src: (d) -> d

    image.exit().remove()

  draw_person: () ->
    info = @selection.get()

    if info is null
      @d3el.classed 'hidden', true
      return

    @d3el.classed 'hidden', false

    # img
    @draw_top_image ['img/person.jpg']

    # description
    description = @d3el.selectAll '.description'
      .attrs
        class: 'description person'
      .html ''
    
    person_img = description.append 'div'
    person_info = description.append 'div'

    person_img.append 'img'
      .attrs
        class: 'profile_img'
        src: info.img

    person_info.append 'div'
      .attrs
        class: 'label'
      .text info.label

    # place
    place = person_info.append 'div'
    place.append 'span'
      .html '<i class="fa fa-map-marker" aria-hidden="true"></i> '
    place.append 'span'
      .text "#{info.institute}, room #{info.room}"

    # phone
    phone = person_info.append 'div'
    phone.append 'span'
      .html '<i class="fa fa-phone" aria-hidden="true"></i> '
    phone.append 'a'
      .attrs
        href: "tel:#{info.phone}"
        target: '_blank'
      .text info.phone

    # email
    email = person_info.append 'div'
    email.append 'span'
      .html '<i class="fa fa-envelope-o" aria-hidden="true"></i> '
    email.append 'a'
      .attrs
        href: "mailto:#{info.email}"
        target: '_blank'
      .text info.email

    # homepage
    homepage = person_info.append 'div'
    homepage.append 'span'
      .html '<i class="fa fa-globe" aria-hidden="true"></i> '
    homepage.append 'a'
      .attrs
        href: info.homepage
        target: '_blank'
      .html info.homepage.replace /http[s]?:\/\//, ''

  draw_place: () ->    
    info = @selection.get()

    if info is null
      @d3el.classed 'hidden', true
      return

    @d3el.classed 'hidden', false

    # img
    @draw_top_image if info? then [info.img] else []

    # description
    place = @d3el.selectAll '.description'
      .data if info? then [info.label] else []

    enter_place = place.enter().append 'div'
      .attrs
        class: 'description place'

    enter_place.merge(place)
      .text (d) -> d

    place.exit().remove()

    # message
    message = @d3el.selectAll '.message'
      .data if info? then [] else ['Nessun Risultato trovato']

    enter_message = message.enter().append 'div'
      .attrs
        class: 'message'

    enter_message.merge(message)
      .text (d) -> d

    message.exit().remove() 
