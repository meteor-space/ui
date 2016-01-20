Space.flux = Space.Module.define('Space.flux', {

  requiredModules: ['Space.messaging'],

  onInitialize() {
    this.injector.map('ReactiveDict').to(ReactiveDict);
  }

});
