
class Space.ui.Mediator extends Space.Object

  Dependencies:
    templates: 'Template'
    eventBus: 'Space.messaging.EventBus'

  onDependenciesReady: -> @setupState()

  # The managed blaze template was created
  templateCreated: (@template) ->

  # The managed blaze template was rendered
  templateRendered: (template) ->

  # The managed blaze template was destroyed
  templateDestroyed: (template) ->

  publish: (event) -> @eventBus.publish event

Space.ui.Mediator.mixin Space.ui.Stateful
