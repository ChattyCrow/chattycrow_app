class AccountService
  # Constructor
  constructor: (settings) ->
    @settingsService = settings
    @lastEmail = window.localStorage.getItem 'lastEmail'

  # Get account informations
  getInfo: (email, password, cb) ->
    # Set last email
    @lastEmail = email
    window.localStorage.setItem 'lastEmail', email, null

    # Try to send via ajax to server!
    $.ajax
      url: "#{settingsService.hostUrl}/user".replace('//', '/')
      method: "POST"
      headers:
        'Contact-Token': settingsService.contactToken
      data: JSON.stringify
        user:
          email: email
          password: password
      contentType: "application/json; charset=utf-8"
      dataType: 'json'
      success: (data) ->
        cb null, data
      error: (data) ->
        cb data, null
