/**
 * Provides a convenience layer for mapping specific parts
 * within space applications as singletons by listing their
 * full namespace paths in arrays like:
 * controllers: ['My.awesome.Controller', 'My.second.Controller']
**/

Space.Module.mixin({

  controllers: [],
  components: [],

  onDependenciesReady: function() {
    this._wrapLifecycleHook('onInitialize', this._onInitializeUi);
    this._wrapLifecycleHook('afterInitialize', this.afterInitializeUi);
  },

  /**
   * This life-cycle hook is called during initialization of the space
   * application and sets up the singleton mappings and UI components.
  **/
  _onInitializeUi(onInitialize) {
    // Map service-like classes that need to run during the complete
    // life-cycle of a space application as singletons.
    let mapAsSingleton = function(klass) {
      this.injector.map(klass).asSingleton();
    };
    _.each(this.controllers, mapAsSingleton, this);

    /**
     * The integration with blaze components is handled in the `onCreate`
     * hook of the component, that's why we provide the app instance so that
     * the blaze components can register themselves as soon as they are ready
     */
    _.each(this.components, function setupBlazeComponents(componentPath) {
      let component = Space.resolvePath(componentPath);
      if (component === null) {
        throw new Error('Space.Module could not resolve component class <' + componentPath + '>');
      }
      component.Application = this.app;
    }, this);

    onInitialize.call(this);
  },

  /**
   * This life-cycle hook is called when the app starts to run
   * and creates the singleton instances.
   */
  afterInitializeUi(afterInitialize) {
    let createSingletonInstance = _.bind(function(klass) {
      this.injector.create(klass);
    }, this);
    _.each(this.controllers, createSingletonInstance);
    afterInitialize.call(this);
  }
});
