class Home
  constructor: (historyService, pushService) ->
    @historyService = historyService
    @pushService    = pushService
    @el = $('<div/>')
    @el.on 'click', '#signInPush', (evt) ->
      evt.preventDefault()

      # Push services
      if pushService.isRegistered()
        alert 'Already registered'
      else
        pushService.register()

    @el.on 'click', '#signOutPush', (evt) ->
      evt.preventDefault()
      pushService.unregister()

    @el.on 'click', '#sendPosition', (evt) ->
      evt.preventDefault()
      window.plugins.spinnerDialog.show(null, 'Obtaining position ...')
      if pushService.isRegistered()
        navigator.geolocation.getCurrentPosition(
          (position) ->
            sendToChattyCrow pushService.getPushId(), position.coords.latitude, position.coords.longitude, (err, suc) ->
              if err
                alert 'Error while sending position'
              else
                alert 'Position has been sent'
              window.plugins.spinnerDialog.hide()
        ,
          () ->
            window.plugins.spinnerDialog.hide()
            alert('Error getting location')
        )
      else
        alert 'Please register push ID'

    @render

  render: ->
    @el.html(@template
      history: @historyService
      pushRegistered: @pushService.isRegistered()
    )
    this
