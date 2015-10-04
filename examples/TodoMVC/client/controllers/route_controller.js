
Space.messaging.Controller.extend(TodoMVC, 'RouteController')

// Tell the rest of the application that the expected filter mode changed
.on(TodoMVC.FilterRouteTriggered, function(event) {
  this.publish(new TodoMVC.FilterChanged({
    filter: event.filterType
  }));
});
