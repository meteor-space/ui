Space.flux.Reactive = {

  dependencies: {
    tracker: 'Tracker'
  },

  _computations: null,

  onDependenciesReady() {
    this._computations = [];
    for (computation of this.computations()) {
      this._computations.push(
        this.tracker.autorun(_.bind(computation, this), {
          onError: this.onComputationError
        })
      );
    }
  },

  computations() {
    return [];
  },

  stopComputations() {
    for (computation of this._computations) {
      computation.stop();
    }
  },

  onComputationError(error) {
    throw error;
  }

};
