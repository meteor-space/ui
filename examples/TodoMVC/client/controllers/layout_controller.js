
Space.messaging.Controller.extend(TodoMVC, 'LayoutController', {
  Dependencies: {
    layout: 'FlowLayout'
  }
})

.on(TodoMVC.FilterRouteTriggered, function(event) {
  this.layout.render("index");
});
