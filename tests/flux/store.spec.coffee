
{Store} = Space.ui

describe 'Space.ui.Store', ->

  beforeEach ->
    @state = new ReactiveVar()
    @store = new Store()
    @store.state = @state
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