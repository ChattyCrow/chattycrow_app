class Home
  constructor: (historyService, pushService) ->
    @historyService = historyService
    @pushService    = pushService
    @el = $('<div/>')

    @el.on 'click', '#registerAgain', (evt) ->
      evt.preventDefault()
      pushService.register()

    @el.on 'click', '#sendPosition', (evt) ->
      evt.preventDefault()
      if pushService.isRegistered()
        window.plugins.spinnerDialog.show(null, 'Obtaining position ...')
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
      pushRegistered: @pushService.isRegistered(),
      pushId: window.localStorage.getItem('pushId')
    )
    this
