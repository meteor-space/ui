
RouteController = Space.messaging.Controller.extend('RouteController')

// Tell the rest of the application that the expected filter mode changed
.on(FilterRouteTriggered, function(event) {
  this.publish(new FilterChanged({
    filter: event.filterType
  }));
});
