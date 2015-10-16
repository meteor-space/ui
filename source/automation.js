// Extend the base modules with space-flux specific sugar (see below)
Space.flux.Module = Space.Module.extend();
Space.flux.Application = Space.Application.extend();

/**
 * Provides a convenience layer for mapping common components
 * within space applications as singletons by listing their
 * full namespace paths in arrays like:
 * Stores: ['My.awesome.Store', 'My.second.Store']
**/

automatedMappings = {
  Stores: [],
  Controllers: [],
  Components: [],
  /**
   * This life-cycle hook is called during initialization of the space
   * application and sets up the singleton mappings and UI components.
  **/
  configure: function() {
    // Map service-like classes that need to run during the complete
    // life-cycle of a space application as singletons.
    var mapAsSingleton = function(klass) {
      this.injector.map(klass).asSingleton();
    };
    _.each(this.Stores, mapAsSingleton, this);
    _.each(this.Controllers, mapAsSingleton, this);

    /**
     * The integration with blaze components is handled in the `onCreate`
     * hook of the component, that's why we provide the app instance so that
     * the blaze components can register themselves as soon as they are ready
     */
    _.each(this.Components, function setupBlazeComponents(componentPath) {
      var component = Space.resolvePath(componentPath);
      if(component === null) {
        throw new Error('Space.Module could not resolve component class <' + componentPath + '>');
      }
      component.Application = this.app;
    }, this);
  },

  /**
   * This life-cycle hook is called when the app starts to run
   * and creates the singleton instances.
   */
  startup: function() {
    var createSingletonInstance = _.bind(function(klass) {
      this.injector.create(klass);
    }, this);
    _.each(this.Stores, createSingletonInstance);
    _.each(this.Controllers, createSingletonInstance);
  }
};

// Make the auto-mapping sugar available for modules and applications
_.extend(Space.flux.Module.prototype, automatedMappings);
_.extend(Space.flux.Application.prototype, automatedMappings);
