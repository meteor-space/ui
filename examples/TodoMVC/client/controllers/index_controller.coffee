
class @IndexController

  Dependencies:
    tracker: 'Tracker'
    router: 'Router'
    eventBus: 'Space.messaging.EventBus'

  onDependenciesReady: ->

    self = this
    # redirect to show all todos by default
    @router.route '/', -> @redirect '/all'

    # handles filtering of todos
    @router.route '/:_filter', name: 'index', onBeforeAction: ->
      # dispatch action non-reactivly to prevent multiple calls
      self.tracker.nonreactive => self._setFilter @params._filter
      @next()

  _setFilter: (filter) => @eventBus.publish new FilterChanged filter: filter
