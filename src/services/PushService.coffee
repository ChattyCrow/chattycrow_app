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
     null

   # Fail!
   fail: (evt) ->
     console.log evt

   # Reaction to push
   pushRecv: (push) ->
     @historyService.addPush push
     # Save push
     alert 'Push recieved'

   # Store local push ID
   storePushId: (id) ->
     # Persist pushId in local storage
     window.localStorage.setItem('pushId', id)

     # Set to element
     $('#pushId').html(id)

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
         # Alert fail
         alert 'Registration success'
