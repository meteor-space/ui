Space.ui = Space.Module.define('Space.ui', {

  requiredModules: ['Space.messaging'],

  onInitialize() {
    this.injector.map('ReactiveDict').to(ReactiveDict);
  }

});
