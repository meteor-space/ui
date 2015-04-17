
class Space.ui.Store extends Space.messaging.Controller
  onDependenciesReady: ->
    super
    @setupState()

Space.ui.Store.mixin Space.ui.Stateful
