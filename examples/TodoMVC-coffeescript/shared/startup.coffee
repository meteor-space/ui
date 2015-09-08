
Meteor.startup =>
  TodoMVC.instance = new TodoMVC()
  TodoMVC.instance.start()
  FlowRouter.initialize()
