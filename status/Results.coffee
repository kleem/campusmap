observable class Results
  constructor: (conf) ->
    @init
      events: ['change', 'change_focused']

    @results = null
    @focused = null
  
  get: () ->
    return @results

  set: (results) ->
    @results = results
    @focused = null

    @trigger 'change'

  get_focused: () ->
    if @focused? then @results[@focused] else null

  check_focused: (d) ->
    return @results? and d is @results[@focused]

  clear: () ->
    @set null

  prev: () ->

    if @focused is null
      @focused = @results.length-1
    else if @focused > 0
      @focused -= 1
    else
      @focused = null

    @trigger 'change'
    @trigger 'change_focused'

  next: () ->  

    if @focused is null
      @focused = 0
    else if @focused < @results.length-1
      @focused += 1
    else
      @focused = null

    @trigger 'change'
    @trigger 'change_focused'