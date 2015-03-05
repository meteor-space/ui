
class Space.ui.Mediator

  Dependencies:
    templates: 'Template'
    eventBus: 'Space.messaging.EventBus'

  # The managed blaze template was created
  templateCreated: (@template) ->

  # The managed blaze template was rendered
  templateRendered: (template) ->

  # The managed blaze template was destroyed
  templateDestroyed: (template) ->

  publish: (event) -> @eventBus.publish event
