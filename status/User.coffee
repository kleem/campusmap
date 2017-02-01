class User
  constructor: (conf) ->
    # Storage browser support check
    if typeof(Storage)?
      if localStorage.user?
        @set localStorage.user
    else
      console.warn 'Sorry! No Web Storage support..'

  set: (user) ->
    @type = user
    localStorage.user = user