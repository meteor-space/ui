
{Store} = Space.ui

describe 'Space.ui.Store', ->

  beforeEach ->
    @state = new ReactiveVar()
    @store = new Store()
    @store.state = @state
    @store.underscore = _
    @store.onDependenciesReady()

  describe 'working with state', ->

    it 'should be empty by default', ->
      expect(@store.getState()).to.deep.equal {}

    it 'can be set as a whole', ->
      value = {}
      @store.setState value
      expect(@store.getState()).to.equal value

    it 'can handle nested properties', ->
      value = {}
      @store.setState 'my.nested.value', value
      expect(@store.getState().my.nested.value).to.equal value
      expect(@store.getState('my.nested.value')).to.equal value

    it 'has aliases for getting and setting state', ->
      expect(@store.get).to.equal @store.getState
      expect(@store.set).to.equal @store.setState

    it 'replaces the existing state object with a fresh one', ->
      @store.set 'nested.state', 'test'
      existingState = @store.get()
      @store.set 'nested.state', 'bla'
      newState = @store.get()
      expect(newState).not.to.equal existingState

    it 'the state can be watched reactively', ->
      callCount = 0
      first = null
      second = {}
      @store.set first: null, second: second

      computation = Tracker.autorun =>
        callCount++
        first = @store.get 'first'
        second = @store.get 'second'

      newValue = {}
      @store.set 'first', newValue
      Tracker.flush()
      computation.stop()
      
      expect(callCount).to.equal 2
      expect(first).to.equal newValue
      expect(second).to.equal second
