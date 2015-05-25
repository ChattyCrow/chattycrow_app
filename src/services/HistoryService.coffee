class HistoryService
  # Init instance variables
  constructor: ->
    @pushes = window.localStorage.getItem 'pushes'

    if @pushes == null
      @pushes = []
    else
      @pushes = JSON.parse @pushes

    # Total count
    @pushesCount = @pushes.length

  # Clear history
  clearHistory: () ->
    @pushes = []
    @pushesCount = 0
    window.localStorage.setItem 'pushes', JSON.stringify(@pushes)

  # Add push to history
  addPush: (content) ->
    # Get today
    d = new Date()

    # Add push with time
    @pushes.unshift
      date: "#{d.getDate()}.#{d.getMonth()}.#{d.getFullYear()} #{d.getHours()}:#{d.getMinutes()}"
      message: JSON.stringify(content, undefined, 2)

    # Save to local storage
    window.localStorage.setItem 'pushes', JSON.stringify(@pushes)

    # Recount count
    @pushesCount++

    # Refresh home view
    $('#pushCount').html(@pushesCount)
