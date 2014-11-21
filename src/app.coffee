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
pushService     = new PushService()

# Local functions
showAbout = (evt) ->
  evt.preventDefault()
  alert('(c) Strnadj, 2014')

exitApp = (evt) ->
  evt.preventDefault()
  navigator.app.exitApp()

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
  $('a.about').on('click', showAbout)
  $('a.exitApp').on('click', exitApp)

  # Override default notifications
  if navigator.notification
    window.alert = (message) ->
      navigator.notification.alert(message, null, 'ChattyCrow', 'OK')
, false
