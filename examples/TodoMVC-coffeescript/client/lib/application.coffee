
class @TodoMVC extends Space.ui.Application

  RequiredModules: ['Space.ui']
  Stores: ['TodosStore']
  Components: [
    'Input'
    'Footer'
    'TodoList'
  ]
  Controllers: ['RouteController', 'LayoutController']
  Singletons: ['TodosTracker']

  Dependencies:
    eventBus: 'Space.messaging.EventBus'

  publish: (event) -> @eventBus.publish event
