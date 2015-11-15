let BlazeComponentsPackage = Package['peerlibrary:blaze-components'];

if (BlazeComponentsPackage !== undefined) { // weak dependency
  let BlazeComponent = BlazeComponentsPackage.BlazeComponent;

  Space.flux.BlazeComponent = Space.Object.extend();

  // Make it a Blaze Component by copying over static and prototype properties
  for (let property in BlazeComponent) {
    if (property !== '__super__') {
      Space.flux.BlazeComponent[property] = BlazeComponent[property];
    }
  }
  for (let property in BlazeComponent.prototype) {
    if (property !== 'constructor') {
      let value = BlazeComponent.prototype[property];
      Space.flux.BlazeComponent.prototype[property] = value;
    }
  }

  // Mixin convenient dependencies
  _.deepExtend(Space.flux.BlazeComponent.prototype, {

    dependencies: {
      eventBus: 'Space.messaging.EventBus'
    },

    onCreated: function() {
      this.constructor.Application.injector.injectInto(this);
    },

    publish: function(event) {
      this.eventBus.publish(event);
    }

  });
}
