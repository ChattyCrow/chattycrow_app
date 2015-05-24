router = do ->
  addRoute = (router, handler) ->
    routes.push
      parts: router.split '/'
      handler: handler

  load = (route) ->
    window.location.hash = route

  start = ->
    path        = window.location.hash.substr 1
    parts       = path.split '/'
    partsLength = parts.length

    for route, i in routes
      if route.parts.length == partsLength
        params = []

        j = 0
        while j < partsLength
          if route.parts[j].substr(0, 1) == ':'
            params.push parts[j]
          else if route.parts[j] != parts[j]
            break

          j++

        if j == partsLength
          route.handler.apply undefined, params
          return

  'use strict'
  $(window).on 'hashchange', start
  routes = []

  {
    addRoute: addRoute
    load:     load
    start:    start
  }
