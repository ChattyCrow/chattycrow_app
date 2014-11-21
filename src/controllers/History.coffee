class History
  constructor: (service) ->
    @service = service
    @el = $('<div/>')
    @render

  render: ->
    @el.html(@template())
    this


