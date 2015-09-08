
TodoMVC = Space.ui.Application.extend('TodoMVC', {

  RequiredModules: ['Space.ui'],
  Stores: ['TodosStore'],
  Mediators: ['TodoListMediator'],
  Components: ['InputComponent', 'FooterComponent'],
  Controllers: ['RouteController', 'LayoutController'],
  Singletons: ['TodosTracker'],

  Dependencies: {
    eventBus: 'Space.messaging.EventBus'
  },

  publish: function(event) {
    this.eventBus.publish(event);
  }

});
