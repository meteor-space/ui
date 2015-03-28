
class Space.ui.Store extends Space.messaging.Controller

  onDependenciesReady: ->
    super
    # Make the initial state setting also reactive
    # so that one can use Collection#findOne without problems
    @tracker.autorun => @state.set @setInitialState()

  setInitialState: -> {}

Space.ui.Store.mixin Space.ui.Stateful
