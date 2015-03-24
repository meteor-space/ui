
{Stateful} = Space.ui

describe 'Space.ui.Stateful', ->

  class TestClass extends Space.Object
    @mixin Stateful

  beforeEach ->
    @state = new ReactiveVar()
    @stateful = new TestClass()
    @stateful.state = @state
    @stateful.underscore = _
    @stateful.tracker = Tracker

  describe 'working with state', ->

    it 'should be null by default', ->
      expect(@stateful.get()).to.be.undefined

    it 'can be set as a whole', ->
      value = {}
      @stateful.set value
      expect(@stateful.get()).to.equal value

    it 'can handle nested properties', ->
      value = {}
      @stateful.set 'my.nested.value', value
      expect(@stateful.get().my.nested.value).to.equal value
      expect(@stateful.get('my.nested.value')).to.equal value

    it 'replaces the existing state object with a fresh one', ->
      @stateful.set 'nested.state', 'test'
      existingState = @stateful.get()
      @stateful.set 'nested.state', 'bla'
      newState = @stateful.get()
      expect(newState).not.to.equal existingState

    it 'the state can be watched reactively', ->
      callCount = 0
      first = null
      second = {}
      @stateful.set first: null, second: second

      computation = Tracker.autorun =>
        callCount++
        first = @stateful.get 'first'
        second = @stateful.get 'second'

      newValue = {}
      @stateful.set 'first', newValue
      Tracker.flush()
      computation.stop()

      expect(callCount).to.equal 2
      expect(first).to.equal newValue
      expect(second).to.equal second

    it 'setting the state doesnt trigger reactivity', ->

      callCount = 0

      computation = Tracker.autorun =>
        @stateful.set 'test', 'test'
        callCount++

      @stateful.set 'test', 'change'
      Tracker.flush()
      computation.stop()
      expect(callCount).to.equal 1
