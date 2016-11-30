class SpecificInfo extends View
  constructor: (conf) ->
    super(conf)

    @container = conf.container
    @selection = conf.selection

  draw_section: (nodes_data, header) ->
    if nodes_data.length > 0
      @container.append 'div'
        .attrs
          class: 'label'
        .text header

      nodes_container = @container.append 'div'
        .attrs
          class: 'nodes'

      nodes = nodes_container.selectAll '.node'
        .data nodes_data

      enter_nodes = nodes.enter().append 'div'
        .attrs
          class: 'node'
        .on 'click', (d) => @selection.set d

      enter_nodes.append 'div'
        .attrs
          class: 'img'
        .styles
          'background-image': (d) -> "url(#{d.thumbnail})"
        .html (d) -> if d.icon? and not d.thumbnail? then "<i class='icon fa fa-fw #{d.icon}'></i>" else ''

      enter_nodes.append 'div'
        .attrs
          class: 'node_label'
        .text (d) -> d.label
