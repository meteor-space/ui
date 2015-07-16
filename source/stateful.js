/**
 * This is a mixin that provides a convenience layer to work with reactive
 * state in any class. It is used by stores and mediators as well as the
 * modified space-ui version of blaze components.
 */
Space.ui.Stateful = {

  Dependencies: {
    state: 'ReactiveVar',
    underscore: 'underscore',
    tracker: 'Tracker'
  },

  /**
   * This has to be called once by the receiving class
   * to initialize the default and reactive state.
   */
  setupState: function() {
    // Assign the (non-reactive) default state first
    this.set(this.setDefaultState());

    // Loop over the reactive state properties and assign them
    // so that they don't override the defaults.
    function assignReactiveState() {
      var reactiveState = this.setReactiveState();
      for(var key in reactiveState) {
        this.set(key, reactiveState[key]);
      }
    }
    // Make it reactive via autorun
    this.tracker.autorun(_.bind(assignReactiveState, this));
  },

  /**
   * Override this in the receiving class to define the default state.
   * Default state is not reactive, so you can assign <null> or other
   * default values that should not be re-assigned later on.
   */
  setDefaultState: function() {
    return {}; // empty by default
  },

  /**
   * Override this in the receiving class to define reactive state.
   * Reactive state registers tracker dependencies and is re-assigned
   * everytime a computation is invalidated.
   * TODO: setInitialState is depricated in favor of setReactiveState
   */
  setReactiveState: function() {
    if(_.isFunction(this.setInitialState)) {
      console.warn('Space.ui.Stateful::setInitial is depricated, use ::setReactiveState instead.');
      return this.setInitialState();
    }
    else {
      return {}; // empty by default
    }
  },

  /**
   * Get a state property at the provided path, e.g: get('my.nested.property')
   * If no path is given, the whole state object is returned.
   * This registers a reactive dependency if run inside a computation.
   */
  get: function(path) {
    if(path !== undefined) {
      path = path.split(".");
    }
    else {
      path = [];
    }
    var state = this.state.get(),
        key = null;
    for(var index=0; index < path.length; index++) {
      // Move down the namespace path
      key = path[index];
      state = state[key];
    }
    return state;
  },

  /**
   * Set a state property at given path to the provided value.
   * If no path is given, then the whole state object will be replaced
   * with the provided value.
   */
  set: function(path, value) {

    // Option 1: Change the whole state at once if no path is given

    if(arguments.length < 2) {
      value = path;
      this.state.set(value);
      return;
    }

    // Option 2: Set nested property at path

    // Get existing state without registering reactive dependencies
    var existingState = this.tracker.nonreactive(_.bind(this.get, this)),
        newState = null;

    if(_.isObject(existingState)) {
      // Make a copy of the existing state so that the reactive var always
      // invalidates, even though we maybe just change a nested property.
      // TODO: Find a better way to work with reactive state, because this is
      // actually creating some weird issues down the line.
      newState = this.underscore.clone(existingState);
    }
    else {
      newState = {};
    }

    path = path.split("."); // Turn path string to an array of nested keys
    var property = newState, // Start at the root of the new state
        key = null,
        hasNextKey = false;

    for(var index=0; index < path.length; index++) {
      hasNextKey = index + 1 < path.length;
      key = path[index];
      if(hasNextKey) {
        if(_.isUndefined(property[key])) {
          property[key] = {}; // Build up missing object path
        }
        property = property[key]; // Move on to the next key
      }
      else {
        // Assign new value to the target property
        property[key] = value;
      }
    }

    // Update the whole state object with the modified copy
    this.state.set(newState);
  }
};

// Assign aliases for occasions where getState is more descriptive
Space.ui.Stateful.getState = Space.ui.Stateful.get;
Space.ui.Stateful.setState = Space.ui.Stateful.set;
