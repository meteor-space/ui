
Space.ui = Space.Module.extend(function() {
  // static
  this.publish(this, 'Space.ui');

  // prototype
  return {
    RequiredModules: ['Space.messaging'],
    configure: function() {
      this.injector.map('Space.ui.TemplateMediatorMap').asSingleton();
    }
  };
});
