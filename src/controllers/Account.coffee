class Account
  constructor: (service) ->
    @service = service
    @el = $('<div/>')
    @render
    that = @

    @el.on 'click', '#startCheck', (evt) ->
      evt.preventDefault()
      that.startCheck()

  startCheck: ->
    window.plugins.spinnerDialog.show(null, 'Retrieving informations ...')

    @service.getInfo $('#email').val(), $('#password').val(), (err, data) ->
      window.plugins.spinnerDialog.hide()
      if err
        alert 'Invalid user'
      else
        data = data.user
        $('#loginForm').parent().hide()
        info = $('#informations')
        info.show()

        # Clear
        info.html ''

        # Create DOM
        ret = '<ul class="table-view">'

        ret += '<li class="table-view-divider">Program</li>'
        ret += '<li class="table-view-cell"><strong>Type: </strong> ' + data.program.program + '</li>'

        percentage = 100 * (data.program.today / data.program.total)
        ret += "<li class='table-view-cell'><strong>Requests left:</strong><br /><div style='width: 100%; text-align: center;'><div class='chart' data-percent='#{percentage}'><span>#{percentage}</span>%</div></div></li>"

        ret += '<li class="table-view-divider">Applications</li>'

        for app in data.apps
          ret += "<li class='table-view-cell'>"
          ret += "<strong>#{app.name}</strong><br /><div class='service-list'>"

          for service in app.channels
            ret += "<div class='#{service.service.toLowerCase()}'>#{service.name}</div>"

          ret += "</div></li>"

        ret += '</ul>'

        info.html(ret).promise().done () ->
          $('.chart').easyPieChart
            animate: 1000
            onStep: (from, to, currentValue) ->
              $(this.el).find('span').text(~~currentValue)

  render: ->
    @el.html(@template(@service))
    this
