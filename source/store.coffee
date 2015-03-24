
class Space.ui.Store extends Space.messaging.Controller

  onDependenciesReady: ->
    super
    @state.set @setInitialState()

  setInitialState: -> {}

Space.ui.Store.mixin Space.ui.Stateful
