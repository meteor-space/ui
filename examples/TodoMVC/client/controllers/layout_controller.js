
LayoutController = Space.messaging.Controller.extend('LayoutController', {
  Dependencies: {
    layout: 'FlowLayout'
  }
})

.on(FilterRouteTriggered, function(event) {
  this.layout.render("index");
});
