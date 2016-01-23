let BlazeComponentsPackage = Package['peerlibrary:blaze-components'];

if (BlazeComponentsPackage !== undefined) { // weak dependency
  let BlazeComponent = BlazeComponentsPackage.BlazeComponent;

  Space.ui.BlazeComponent = Space.Object.extend();

  // Make it a Blaze Component by copying over static and prototype properties
  for (let property in BlazeComponent) {
    if (property !== '__super__') {
      Space.ui.BlazeComponent[property] = BlazeComponent[property];
    }
  }
  for (let property in BlazeComponent.prototype) {
    if (property !== 'constructor') {
      let value = BlazeComponent.prototype[property];
      Space.ui.BlazeComponent.prototype[property] = value;
    }
  }

  Space.ui.BlazeComponent.mixin({

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
      this.stopComputations();
    },

    publish(event) {
      this.eventBus.publish(event);
    }

  });

  Space.ui.BlazeComponent.mixin(Space.ui.Stateful);
  Space.ui.BlazeComponent.mixin(Space.ui.Reactive);
}
