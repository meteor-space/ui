if Package['peerlibrary:blaze-components']? # weak dependency
  BlazeComponent = Package['peerlibrary:blaze-components'].BlazeComponent

  class Space.ui.BlazeComponent extends Space.Object

  # Make it a Blaze Component.
  for property, value of BlazeComponent when property not in ['__super__',]
    Space.ui.BlazeComponent[property] = value

  for property, value of (BlazeComponent::) when property not in ['constructor']
    Space.ui.BlazeComponent::[property] = value

  Space.ui.BlazeComponent.mixin

    Dependencies:
      eventBus: 'Space.messaging.EventBus'

    onCreated: ->
      @constructor.Application.injector.injectInto this
      @setupState()

    publish: (event) -> @eventBus.publish event

  Space.ui.BlazeComponent.mixin Space.ui.Stateful
