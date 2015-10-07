
Space.messaging.Controller.extend(Space.ui, 'Store', {

  Dependencies: {
    injector: 'Injector',
    _: 'underscore',
  },

  onDependenciesReady: function() {
    Space.messaging.Controller.prototype.onDependenciesReady.call(this);
    this._setupReactiveVars();
  },

  reactiveVars: function() {
    return [];
  },

  /**
   * Initialize the reactive vars with default values.
   */
  _setupReactiveVars: function() {
    var reactiveVars = {};
    var reactiveVarMaps = this.reactiveVars();
    reactiveVarMaps.unshift(reactiveVars);
    this._.extend.apply(null, reactiveVarMaps);
    this._.each(reactiveVars, this._generateReactiveVarAccessor, this);
  },

  /**
   * Generates a method on this class instance for each reactive var
   * that can be used to set and get the value of it.
   */
  _generateReactiveVarAccessor: function(defaultValue, varName) {
    var reactiveVar = this.injector.get('ReactiveVar');
    reactiveVar.set(defaultValue);

    this[varName] = function(value) {
      if(value !== undefined) {
        reactiveVar.set(value);
      }
      else {
        return reactiveVar.get();
      }
    };
  }
});
