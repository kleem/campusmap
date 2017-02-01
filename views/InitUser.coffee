observer class InitUser extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @user = conf.user

    if @user.type?
      @close()
    else
      @open()

  open: () ->
    @panel = @d3el.append 'div'
      .attrs
        class: 'panel'

    top = @panel.append 'div'
    profiles = @panel.append 'div'
      .attrs
        class: 'profiles'

    top.append 'div'
      .attrs
        class: 'title'
      .html "Benvenuto nell'Area della Ricerca del Consiglio Nazionale delle Ricerche di Pisa"

    top.append 'div'
      .attrs
        class: 'subtitle'
      .html "Accedi a CampusMap, scegli il tuo profilo."

    guest = profiles.append 'div'
      .attrs
        class: 'user guest'
      .on 'click', () =>
        @close()
        @user.set 'guest'

    guest.append 'div'
      .attrs
        class: 'img'
    guest.append 'div'
      .attrs
        class: 'text'
      .text 'Visitatore'

    worker = profiles.append 'div'
      .attrs
        class: 'user worker'
      .on 'click', () =>
        @close()
        @user.set 'worker'

    worker.append 'div'
      .attrs
        class: 'img'
    worker.append 'div'
      .attrs
        class: 'text'
      .text 'Lavoratore'

  close: () ->
    @d3el.remove()