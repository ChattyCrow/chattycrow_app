class PushService
  isRegistered: ->
    window.localStorage.getItem('pushId') != null

  # Register pushID
  register: ->
    # Clojure
    that = this

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
            "ecb" : "pushService.gcm_event"
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
            "ecb":"pushService.apn_event"
          }
        )

   # Success event
   success: (evt) ->
     null

   # Fail!
   fail: (evt) ->
     console.log evt

   # Store local push ID
   storePushId: (id) ->
     # Persist pushId in local storage
     window.localStorage.setItem('pushId', id)
     $('#log').html(id)

   # React to APNS event
   apn_event: (e) ->
     alert e.payload

   # React to gcm events
   gcm_event: (e) ->
     switch e.event
       when 'registered'
         @storePushId(e.regid)
       when 'message'
         alert 'message'
