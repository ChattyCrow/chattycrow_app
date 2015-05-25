class History
  constructor: (service) ->
    @service = service
    @el = $('<div/>')
    that = @


    @render

  render: ->
    @el.html(@template(@service))
    this


