
Space.flux = Space.Module.define('Space.flux', {
  RequiredModules: ['Space.messaging'],
  configure: function() {
    this.injector.map('ReactiveDict').to(ReactiveDict);
  }
});
