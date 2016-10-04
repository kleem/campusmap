observer class ResultsBox extends View
  constructor: (conf) ->
    super(conf)
    @init()

    @mode = conf.mode
    @query = conf.query

    @innerDiv = @d3el.append 'div'
      .attrs
        class: 'innerResultsBox'

    @listen_to @query, 'change', () => 
      @show_results()
      @show()

  show_results: () =>

    results_text = @innerDiv.selectAll '.results_text'
      .data @query.get_results(), (d) -> d.id

    results_text.enter().append 'p'
      .attrs
        class: 'results_text'
      .text (d) -> d.label

    results_text.exit().remove()

  show: () =>
    @d3el.classed 'displayed', true
