class SettingsService
  # Constructor
  constructor: ->
    @hostUrl = ''
    @contactToken = ''

  # Initialize for router settings
  initialize: ->
    # Prepare deferred
    deffered = $.Deferred()

    # Init instance variables
    @hostUrl = window.localStorage.getItem('hostUrl')
    @contactToken = window.localStorage.getItem('contactToken')

    # If undefined use default variables
    if @hostUrl == null
      @hostUrl = 'https://chattycrow.com/api/v1'

    if @contactToken == null
      @contactToken = ''

    # resolve and return promise
    deffered.resolve()
    deffered.promise()

  # Set push service
  setPushService: (service) ->
    @pushService = service

  # Save settings
  saveSettings: (host, token) ->
    @hostUrl = host
    @contactToken = token

    # Persist in local storage
    window.localStorage.setItem('hostUrl', @hostUrl)
    window.localStorage.setItem('contactToken', @contactToken)
