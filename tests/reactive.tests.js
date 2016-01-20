describe("Space.flux.Reactive", function() {

  beforeEach(function() {
    // Setup reactive stub vars
    this.first = new ReactiveVar(1);
    this.second = new ReactiveVar(1);
    this.throwError = new ReactiveVar(false);
    let context = this;

    // Setup a class that has computations based on these reactive vars
    this.MyReactiveClass = Space.Object.extend('MyReactiveClass', {
      mixin: Space.flux.Reactive,
      sum: null,
      product: null,
      computations() {
        return [this._calcSum, this._calcProduct, this._errorComp];
      },
      _calcSum() {
        this.sum = context.first.get() + context.second.get();
      },
      _calcProduct() {
        this.product = context.first.get() * context.second.get();
      },
      _errorComp() {
        if (context.throwError.get()) {
          throw new Error('test');
        }
      }
    });

    // Provide runtime dependencies and tell class that they are ready
    this.myReactive = new MyReactiveClass({ tracker: Tracker });
    this.myReactive.onDependenciesReady();
  });

  describe("setting up computations", function() {

    it("autoruns them whenever any dep changes", function() {
      // Computations should run immediately
      expect(this.myReactive.sum).to.equal(1 + 1);
      expect(this.myReactive.product).to.equal(1 * 1);
      this.first.set(2);
      Tracker.flush();
      // And re-run after any reactive dep changed
      expect(this.myReactive.sum).to.equal(2 + 1);
      expect(this.myReactive.product).to.equal(2 * 1);
      this.second.set(2);
      Tracker.flush();
      // And re-run after any reactive dep changed
      expect(this.myReactive.sum).to.equal(2 + 2);
      expect(this.myReactive.product).to.equal(2 * 2);
    });

  });

  describe("cleaning up computations", function() {

    it("can cleanup all computations at once", function() {
      this.myReactive.stopComputations();
      this.first.set(2);
      this.second.set(2);
      Tracker.flush();
      // The computations should not have run anymore
      expect(this.myReactive.sum).to.equal(2);
      expect(this.myReactive.product).to.equal(1);
    });

  });

  describe("computation errors", function() {

    it("re-throws them as normal errors", function() {
      let computationError = () => {
        this.throwError.set(true);
        Tracker.flush();
      };
      expect(computationError).to.throw('test');
    });

  });

});
