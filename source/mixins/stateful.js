Space.flux.Stateful = {

  statics: {
    _session: null
  },

  dependencies: {
    ReactiveVar: 'ReactiveVar',
    ReactiveDict: 'ReactiveDict',
    _: 'underscore',
    tracker: 'Tracker'
  },

  _reactiveVars: null,
  _session: null,
  _computations: null,

  onDependenciesReady: function() {
    this._reactiveVars = {};
    this._setupReactiveVars();
    // Only create one static singleton of the reactive-dict for this class!
    if (this.constructor._session === null) {
      this.constructor._session = new this.ReactiveDict(this._session);
    }
    this._session = this.constructor._session;
    this._setDefaultSessionVars();
    this._computations = [];
    for (computation of this.computations()) {
      this._computations.push(
        this.tracker.autorun(_.bind(computation, this), this._onComputationError)
      );
    }
  },

  reactiveVars: function() {
    return [];
  },

  sessionVars: function() {
    return [];
  },

  computations: function() {
    return [];
  },

  state() {
    let state = {};
    for (let key in this._reactiveVars) {
      if (this._reactiveVars.hasOwnProperty(key)) {
        state[key] = this._reactiveVars[key].get();
      }
    }
    for (let key in this._session.keys) {
      state[key] = this._session.get(key);
    }
    return state;
  },

  /**
   * Initialize the reactive vars with default values.
   */
  _setupReactiveVars: function() {
    let reactiveVars = {};
    let reactiveVarMaps = this.reactiveVars();
    reactiveVarMaps.unshift(reactiveVars);
    this._.extend.apply(null, reactiveVarMaps);
    this._.each(reactiveVars, this._generateReactiveVar, this);
  },

  /**
   * Generates a method on this class instance for each reactive var
   * that can be used to get the value of it.
   */
  _generateReactiveVar: function(defaultValue, varName) {
    let reactiveVar = new this.ReactiveVar();
    reactiveVar.set(defaultValue);
    this._reactiveVars[varName] = reactiveVar;
    this[varName] = function() {
      return reactiveVar.get();
    };
  },

  /**
   * Initialize the session vars with default values.
   */
  _setDefaultSessionVars: function() {
    let sessionVars = {};
    let sessionVarMaps = this.sessionVars();
    sessionVarMaps.unshift(sessionVars);
    this._.extend.apply(null, sessionVarMaps);
    this._.each(sessionVars, this._generateSessionVar, this);
  },

  /**
   * Generates a method on this class instance for each session var
   * that can be used to get the value of it.
   */
  _generateSessionVar: function(defaultValue, varName) {
    let session = this._session;
    session.setDefault(varName, defaultValue);
    this[varName] = function() {
      return session.get(varName);
    };
  },

  _setReactiveVar: function(varName, value) {
    let reactiveVar = this._reactiveVars[varName];
    if (!reactiveVar) {
      throw new Error(`Did you forget to setup reactive var <${varName}>?`);
    }
    reactiveVar.set(value);
  },

  _setSessionVar: function(varName, value) {
    this._session.set(varName, value);
  },

  _onComputationError(error) {
    throw error;
  },

  _cleanupComputations() {
    for (computation of this._computations) {
      computation.stop();
    }
  }

};
