
Space.flux = Space.Module.define('Space.flux', {
  RequiredModules: ['Space.messaging'],
  onInitialize: function() {
    this.injector.map('ReactiveDict').to(ReactiveDict);
  }
});
