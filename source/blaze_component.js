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

  Space.flux.BlazeComponent.mixin({

    dependencies: {
      eventBus: 'Space.messaging.EventBus'
    },

    onCreated() {
      if (!this.constructor.Application) {
        throw new Error(`You forgot to map the component <${this}> in your app.`);
      }
      this.constructor.Application.injector.injectInto(this);
    },

    onDestroyed() {
      this._cleanupComputations();
    },

    publish(event) {
      this.eventBus.publish(event);
    }

  });

  Space.flux.BlazeComponent.mixin(Space.flux.Stateful);
  Space.flux.BlazeComponent.mixin(Space.flux.Reactive);
}
