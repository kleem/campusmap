observable class Selection
  constructor: (conf) ->
    @init
    	events: ['change']

    @graph = conf.graph

    # react to hash URI changes
    d3.select(window).on 'popstate', () =>
      node_id = document.location.hash.replace('#','')
      node = @graph.get_node(node_id)
      if node?
        @set node, false # don't save this into the history
      else
        @set null, false # don't save this into the history

  unset: () ->
    @set null

  # set the selection to the given node, save the selection into the browser's
  # history, then trigger 'change'
  set: (node, save) ->
    save = if save? then save else true

    if node isnt @selection
      @selection = node

      # save this selection into the browser's history
      if save
        if @selection?
          # update the browser's history
          history.pushState null, @selection.label, '#'+@selection.id
        else
          history.pushState null, '', '#' # null state

      @trigger 'change'

  get: () ->
    return @selection
