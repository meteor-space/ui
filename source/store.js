
Space.messaging.Controller.extend(Space.ui, 'Store', {
  onDependenciesReady: function() {
    Space.messaging.Controller.prototype.onDependenciesReady.call(this);
    this.setupReactiveVars();
  }
});

Space.ui.Store.mixin(Space.ui.Stateful);
