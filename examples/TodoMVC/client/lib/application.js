
TodoMVC = Space.ui.Application.extend('TodoMVC', {

  RequiredModules: ['Space.ui'],
  Stores: ['TodoMVC.TodosStore'],
  Mediators: ['TodoMVC.TodoListMediator'],
  Components: ['TodoMVC.InputComponent', 'TodoMVC.FooterComponent'],
  Controllers: ['TodoMVC.RouteController', 'TodoMVC.LayoutController'],
  Singletons: ['TodoMVC.TodosTracker'],

  Dependencies: {
    eventBus: 'Space.messaging.EventBus'
  },

  publish: function(event) {
    this.eventBus.publish(event);
  }

});
