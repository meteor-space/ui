var BlazeComponentsPackage = Package['peerlibrary:blaze-components'];
if(BlazeComponentsPackage !== undefined) { // weak dependency
  var BlazeComponent = BlazeComponentsPackage.BlazeComponent;

  Space.flux.BlazeComponent = Space.Object.extend();

  // Make it a Blaze Component by copying over static and prototype properties
  for(var property in BlazeComponent) {
    if(property !== '__super__') {
      Space.flux.BlazeComponent[property] = BlazeComponent[property];
    }
  }
  for(var property in BlazeComponent.prototype) {
    if(property !== 'constructor') {
      var value = BlazeComponent.prototype[property];
      Space.flux.BlazeComponent.prototype[property] = value;
    }
  }

  // Mixin convenient dependencies
  Space.flux.BlazeComponent.mixin({

    Dependencies: {
      eventBus: 'Space.messaging.EventBus',
      commandBus: 'Space.messaging.CommandBus'
    },

    onCreated: function() {
      this.constructor.Application.injector.injectInto(this);
    },

    publish: function (event) {
      this.eventBus.publish(event);
    },

    send: function (command) {
      this.commandBus.send(command);
    }
  });
}
