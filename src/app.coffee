# Slider for content
slider = new PageSlider($('.content'))

# Back button
backButton      = $('#backButton')
clearHistoryBtn = $('#clearHistory')

# Prepare compiled templates
Home.prototype.template     = Handlebars.compile($('#home-tpl').html())
Account.prototype.template  = Handlebars.compile($('#account-tpl').html())
About.prototype.template    = Handlebars.compile($('#informations-tpl').html())
History.prototype.template  = Handlebars.compile($('#history-tpl').html())
Settings.prototype.template = Handlebars.compile($('#settings-tpl').html())

# Create services
historyService  = new HistoryService()
settingsService = new SettingsService()
pushService     = new PushService(settingsService, historyService)
accountService  = new AccountService(settingsService)

# Set cross service
settingsService.setPushService pushService

# Send position to chatty crow
sendToChattyCrow = (pushId, lat, lon, cb) ->
  # Try to send via ajax to server!
  $.ajax
    url: "#{settingsService.hostUrl}/locations".replace('//', '/')
    method: "POST"
    headers:
      'Contact-Token': settingsService.contactToken
    data: JSON.stringify
      contact: pushId
      latitude: lat
      longitude: lon
    contentType: "application/json; charset=utf-8"
    dataType: 'json'
    success: (data) ->
      cb null, data
    error: (data) ->
      cb data, null

# React to APNS event
apn_event = (e) ->
  console.log e
  pushService.pushRecv e

# React to WP8 events
wp_event = (e) ->
  console.log "Recv WP8 #{e}"

# React to gcm events
gcm_event = (e) ->
  switch e.event
    when 'registered'
      pushService.storePushId(e.regid)
    when 'message'
      pushService.pushRecv e

# Show informations
showAbout = (evt) ->
  evt.preventDefault()
  alert('Strnadj, 2014')

# Clear history BTN
showLicense = (evt) ->
  evt.preventDefault()
  alert('MIT')

# Dynamically change title text
changeTitleText = (text) ->
  $('.text-second').html(text)
  # Start fade in / fade out
  $('.text-first').animate { opacity: 0.0 }, 500
  $('.text-second').animate { opacity: 1.0 }, 500, ->
    $('.text-first').html(text)
    $('.text-first').css('opacity', '1.0')
    $('.text-second').css('opacity', '0.0')

# Init services
settingsService.initialize().done ->
  # Prepare routes
  router.addRoute '', ->
    slider.slidePage(new Home(historyService, pushService).render().el)
    backButton.hide()
    clearHistoryBtn.hide()
    changeTitleText('ChattyCrow')

  # Account
  router.addRoute 'account', ->
    slider.slidePage(new Account(accountService).render().el)
    clearHistoryBtn.hide()
    backButton.show()
    changeTitleText('Account')

  # About page
  router.addRoute 'informations', ->
    slider.slidePage(new About().render().el)
    clearHistoryBtn.hide()
    backButton.show()
    changeTitleText('About')

  # History
  router.addRoute 'history', ->
    slider.slidePage(new History(historyService).render().el)
    backButton.show()
    clearHistoryBtn.show()
    changeTitleText('History')

  # Settings
  router.addRoute 'settings', ->
    slider.slidePage(new Settings(settingsService).render().el)
    backButton.show()
    clearHistoryBtn.hide()
    changeTitleText('Settings')

  # Start routing
  router.start()

# Push function
document.addEventListener 'deviceready', ->
  StatusBar.overlaysWebView( false )
  StatusBar.backgroundColorByHexString('#ffffff')
  StatusBar.styleDefault()
  FastClick.attach(document.body)

  # Menu Actions
  $('#aboutBtn').on('click', showAbout)
  $('#licenseBtn').on('click', showLicense)

  # Try to register push ID
  pushService.register()

  # Clear history bind
  clearHistoryBtn.on 'click', (evt) ->
    evt.preventDefault()
    historyService.clearHistory()

    # Reload view
    $(window).trigger('hashchange')

  # Override default notifications
  if navigator.notification
    window.alert = (message) ->
      navigator.notification.alert(message, null, 'ChattyCrow', 'OK')

, false
