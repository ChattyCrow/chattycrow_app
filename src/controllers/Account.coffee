class Account
  constructor: ->
    @el = $('<div/>')
    @render
    that = @

    @el.on 'click', '#startCheck', (evt) ->
      evt.preventDefault()
      that.startCheck

  startCheck: ->

  render: ->
    @el.html(@template())
    this
