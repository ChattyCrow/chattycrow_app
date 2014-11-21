class Settings
  constructor: (service) ->
    @service = service
    @el = $('<div/>')

    # Prevent clojure
    that = this
    @el.on 'click', '#saveSettings', ->
      that.saveSettings()

    # Return render
    @render

  render: ->
    @el.html(@template(@service))
    this

  saveSettings: ->
    @service.saveSettings $('#serverHost').val(), $('#contactToken').val()
    window.location = '#'
    alert('Settings was saved')
