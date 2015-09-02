
Space.ui = Space.Module.define('Space.ui', {
  RequiredModules: ['Space.messaging'],
  configure: function() {
    this.injector.map('Space.ui.TemplateMediatorMap').asSingleton();
  }
});
