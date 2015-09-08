Meteor.startup(function() {
  TodoMVC.app = new TodoMVC();
  TodoMVC.app.start();
  FlowRouter.initialize();
});
