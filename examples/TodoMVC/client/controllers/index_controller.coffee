
class @IndexController

  Dependencies:
    tracker: 'Tracker'
    router: 'Router'
    eventBus: 'Space.messaging.EventBus'

  onDependenciesReady: ->

    self = this
    # Redirect to show all todos by default
    @router.route '/', -> @redirect '/all'

    # Handles filtering of todos
    @router.route '/:_filter',

      name: 'index'

      onAfterAction: ->
        # Dispatch action non-reactivly to prevent multiple calls
        # this is a drawback of using iron:router TODO: switch to flow-router?
        self.tracker.nonreactive => self._setFilter @params._filter

      subscriptions: ->
        # Subscribe to the filetered data based on the route parameter
        Meteor.subscribe 'todos', @params._filter

  _setFilter: (filter) => @eventBus.publish new FilterChanged filter: filter
