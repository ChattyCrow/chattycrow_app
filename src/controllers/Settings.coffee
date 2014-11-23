class Settings
  constructor: (service) ->
    @service = service
    @el = $('<div/>')

    that = this
    @el.on 'click', '#saveSettings', (evt) ->
      evt.preventDefault()
      that.saveSettings()


    @el.on 'click', '#scanQRCode', (evt) ->
      evt.preventDefault()
      cordova.plugins.barcodeScanner.scan(
        (result) ->
          if result.text.length > 0
            $('#contactToken').val(result.text)
            alert 'Success'
          else
            alert 'Error while scanning'
        ,
        (error) ->
          alert "Error while scanning #{error}"
      )

    # Return render
    @render

  render: ->
    @el.html(@template(@service))
    this

  saveSettings: ->
    @service.saveSettings $('#serverHost').val(), $('#contactToken').val()
    window.location = '#'
    alert('Settings was saved')
