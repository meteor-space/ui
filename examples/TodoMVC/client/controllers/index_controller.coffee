
class @IndexController extends Space.ui.RouteController

  @toString: -> 'IndexController'

  Dependencies:
    actions: 'Actions'
    tracker: 'Tracker'
    dispatcher: 'Space.ui.Dispatcher'

  configure: ->

    self = this

    # redirect to show all todos by default
    @router.route '/', -> @redirect '/all'

    # handles filtering of todos
    @router.route '/:_filter', {

      name: 'index'

      onBeforeAction: ->
        filter = @params._filter
        # dispatch action non-reactivly to prevent endless-loops
        self.tracker.nonreactive -> self._setFilter filter
        @next()
    }

  _setFilter: (filter) => @dispatch @actions.SET_FILTER, filter
