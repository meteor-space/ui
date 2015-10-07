
Space.messaging.Controller.extend(TodoMVC, 'LayoutController', {
  
  Dependencies: {
    layout: 'FlowLayout'
  },

  events: function() {
    return [{
      'TodoMVC.FilterRouteTriggered': function(event) {
        this.layout.render("index");
      }
    }];
  }
});
