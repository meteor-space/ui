
class @RouteController extends Space.ui.RouteController

  @toString: -> 'RouteController'

  Dependencies:
    indexRoute: 'IndexRoute'
    router: 'Space.ui.Router'

  configure: ->

    # redirect to show all todos by default
    @router.route '/', -> @redirect '/all'

    # the index route handles all filter cases
    @addRoute @indexRoute