/**
 * This is a mixin that provides a convenience layer to work with reactive
 * vars in any class. It is used by stores and components.
 */
Space.ui.Stateful = {

  Dependencies: {
    injector: 'Injector',
    _: 'underscore',
  },

  reactiveVars: function() {
    return [];
  },

  /**
   * This has to be called once by the receiving class
   * to initialize the reactive vars with default values.
   */
  setupReactiveVars: function() {
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
};
