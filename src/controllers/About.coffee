class About
  constructor: ->
    @el = $('<div/>')
    @render

  render: ->
    @el.html(@template())
    this

