Space.flux.Reactive = {

  dependencies: {
    _: 'underscore',
    tracker: 'Tracker'
  },

  _computations: null,

  onDependenciesReady() {
    this._computations = [];
    for (computation of this.computations()) {
      this._computations.push(
        this.tracker.autorun(_.bind(computation, this), this._onComputationError)
      );
    }
  },

  computations() {
    return [];
  }

};
