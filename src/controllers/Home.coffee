class Home
  constructor: (historyService, pushService) ->
    @historyService = historyService
    @pushService    = pushService
    @el = $('<div/>')
    @el.on 'click', '#signInPush', (evt) ->
      # Don't move
      evt.preventDefault()

      # Push services
      if pushService.isRegistered()
        alert 'Already registered'
      else
        pushService.register()

    @render

  render: ->
    @el.html(@template(@historyService))
    this
