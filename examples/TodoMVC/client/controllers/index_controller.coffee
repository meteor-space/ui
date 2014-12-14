
class TodoMVC.IndexController extends Space.ui.RouteController

  Dependencies:
    actions: 'Actions'
    tracker: 'Tracker'

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

  _setFilter: (filter) => @actions.setTodosFilter filter
