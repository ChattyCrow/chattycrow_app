# Slider for content
slider = new PageSlider($('.content'))

# Back button
backButton = $('#backButton')

# Prepare compiled templates
Home.prototype.template = Handlebars.compile($('#home-tpl').html())
About.prototype.template = Handlebars.compile($('#about-tpl').html())
History.prototype.template = Handlebars.compile($('#history-tpl').html())
Settings.prototype.template = Handlebars.compile($('#settings-tpl').html())

# Create services
historyService  = new HistoryService()
settingsService = new SettingsService()
pushService     = new PushService(settingsService, historyService)

# Local functions
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
  alert('(c) Strnadj, 2014')

# Clear history BTN
clearHistory = (evt) ->
  evt.preventDefault()
  historyService.clearHistory()
  alert('History cleared')

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
    changeTitleText('ChattyCrow')

  # About page
  router.addRoute 'about', ->
    slider.slidePage(new About().render().el)
    backButton.show()
    changeTitleText('About')

  # History
  router.addRoute 'history', ->
    slider.slidePage(new History(historyService).render().el)
    backButton.show()
    changeTitleText('History')

  # Settings
  router.addRoute 'settings', ->
    slider.slidePage(new Settings(settingsService).render().el)
    backButton.show()
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
  $('#clearHistory').on('click', clearHistory)

  # Try to register push ID
  pushService.register()

  # Override default notifications
  if navigator.notification
    window.alert = (message) ->
      navigator.notification.alert(message, null, 'ChattyCrow', 'OK')

, false
