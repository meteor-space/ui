
TodoMVC = Space.ui.Application.extend('TodoMVC', {

  RequiredModules: ['Space.ui'],
  Stores: ['TodoMVC.TodosStore'],
  Components: [
    'TodoMVC.Input',
    'TodoMVC.Footer',
    'TodoMVC.TodoList'
  ],
  Controllers: ['TodoMVC.RouteController', 'TodoMVC.LayoutController'],
  Singletons: ['TodoMVC.TodosTracker'],

  Dependencies: {
    eventBus: 'Space.messaging.EventBus'
  },

  publish: function(event) {
    this.eventBus.publish(event);
  }

});
