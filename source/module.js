
Space.flux = Space.Module.define('Space.flux', {
  requiredModules: ['Space.messaging'],
  onInitialize: function() {
    this.injector.map('ReactiveDict').to(ReactiveDict);
  }
});
