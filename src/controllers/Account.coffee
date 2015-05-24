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
    @service.getInfo $('#email').val(), $('#password').val(), (err, data) ->
      if err
        alert 'Invalid user'
      else
        data = data['user']
        $('#loginForm').hide()
        info = $('#informations')
        info.show()

        # Clear
        info.html ''

        # Create DOM
        ret = '<ul class="table-view">'

        ret += '<li class="table-view-divider">Program</li>'
        ret += '<li class="table-view-cell"><strong>Type: </strong> ' + data['program']['program'] + '</li>'

        percentage = 100 * (data['program']['today'] / data['program']['total'])
        ret += "<li class='table-view-cell'><strong>Requests left:</strong><br /><div class='chart' data-percent='#{percentage}'><span>#{percentage}</span>%</div></li>"

        ret += '<li class="table-view-divider">Applications</li>'

        for app in data['apps']
          ret += "<li class='table-view-cell'>"
          ret += "<strong>#{app['name']}<strong><br /><ul>"

          for service in app['channels']
            ret += "<li>#{service['service']} - #{service['name']}</li>"

          ret += "</ul></li>"

        ret += '</ul>'

        info.html(ret).promise().done () ->
          $('.chart').easyPieChart
            animate: 1000
            onStep: (value) ->
              $(this.el).find('span').text(~~value)

  render: ->
    @el.html(@template(@service))
    this
