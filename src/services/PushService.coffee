class PushService
  # Constructor
  constructor: (settings, history) ->
    @settingsService = settings
    @historyService  = history

  # Return push id
  getPushId: ->
    window.localStorage.getItem('pushId')

  isRegistered: ->
    @getPushId() != null

  # Unregister push
  unregister: ->
    that = this

    # Unregister handler
    window.plugins.pushNotification.unregister that.success, that.fail

    # Remove from storage
    window.localStorage.removeItem('pushId')

  # Register pushID
  register: ->
    that = this

    # Show spinner
    window.plugins.spinnerDialog.show(null, 'Registering Push Id')

    # Push notifications
    @pushNotification = window.plugins.pushNotification

    # Device?
    switch device.platform.toLowerCase()
      when 'android'
        @pushNotification.register(
          that.success,
          that.fail,
          {
            "senderID" : "286801227267",
            "ecb" : "gcm_event"
          }
        )
      when 'win32nt'
        @pushNotification.register(
          that.success,
          that.fail,
          {
            "channelName" : "test",
            "ecb" : "wp_event"
          }
        )
      else
        # Ios
        @pushNotification.register(
          that.storePushId,
          that.fail,
          {
            "badge":"true",
            "sound":"true",
            "alert":"true",
            "ecb":"apn_event"
          }
        )

  # Success event
  success: (evt) ->
    if evt.uri
      console.log('registered###' + evt.uri)
    null

  # Fail!
  fail: (evt) ->
    console.log evt

  # Reaction to push
  pushRecv: (push) ->
    # Add push to history
    @historyService.addPush push

     # Save push
    alert 'Push recieved'

    # Reload page if history or homepage?
    if window.location.hash == '#history' || window.location.hash == '#'
      $(window).trigger('hashchange')

  # Store local push ID
  storePushId: (id) ->
    # Persist pushId in local storage
    window.localStorage.setItem('pushId', id)

    # Try to register
    sendToChattyCrow id, 0.0, 0.0, (err, data) ->
      # Hide dialog
      window.plugins.spinnerDialog.hide()

      # Callback
      if err
        # Remove push ID
        window.localStorage.removeItem('pushId')

        # Alert about failed registration
        alert 'Registration fail'
      else
        # Set to element
        $('#pushId').html(id)

        # Alert fail
        alert 'Registration success'
