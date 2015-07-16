var BlazeComponentsPackage = Package['peerlibrary:blaze-components'];
if(BlazeComponentsPackage !== undefined) { // weak dependency
  var BlazeComponent = BlazeComponentsPackage.BlazeComponent;

  Space.ui.BlazeComponent = Space.Object.extend();

  // Make it a Blaze Component by copying over static and prototype properties
  for(var property in BlazeComponent) {
    if(property !== '__super__') {
      Space.ui.BlazeComponent[property] = BlazeComponent[property];
    }
  }
  for(var property in BlazeComponent.prototype) {
    if(property !== 'constructor') {
      var value = BlazeComponent.prototype[property];
      Space.ui.BlazeComponent.prototype[property] = value;
    }
  }

  // Mixin convenient dependencies and make components stateful
  Space.ui.BlazeComponent.mixin({

    Dependencies: {
      eventBus: 'Space.messaging.EventBus'
    },

    onCreated: function() {
      this.constructor.Application.injector.injectInto(this);
      this.setupState();
    },

    publish: function (event) {
      this.eventBus.publish(event);
    }
  });

  Space.ui.BlazeComponent.mixin(Space.ui.Stateful);
}
