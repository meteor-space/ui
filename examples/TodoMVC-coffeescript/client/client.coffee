
class @TodoMVC extends Space.ui.Application

  RequiredModules: ['Space.ui']
  Stores: ['TodosStore']
  Mediators: ['TodoListMediator']
  Components: ['InputComponent', 'FooterComponent']
  Controllers: ['RouteController', 'LayoutController']
  Singletons: ['TodosTracker']

  Dependencies:
    eventBus: 'Space.messaging.EventBus'

  publish: (event) -> @eventBus.publish event
