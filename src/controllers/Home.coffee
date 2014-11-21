class Home
  constructor: (historyService) ->
    @historyService = historyService
    @el = $('<div/>')
    @render

  render: ->
    @el.html(@template(@historyService))
    this
