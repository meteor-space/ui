
Space.messaging.Controller.extend(TodoMVC, 'RouteController', {

  events: function() {
    return [{
      // Tell the rest of the application that the expected filter mode changed
      'TodoMVC.FilterRouteTriggered': function(event) {
        this.publish(new TodoMVC.FilterChanged({
          filter: event.filterType
        }));
      }
    }];
  }

});
