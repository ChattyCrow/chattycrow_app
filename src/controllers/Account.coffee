class Account
  constructor: ->
    @el = $('<div/>')
    @render

  render: ->
    @el.html(@template())
    this
