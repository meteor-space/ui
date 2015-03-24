
{Store} = Space.ui

describe 'Space.ui.Store', ->

  it 'is a messaging controller', ->
    expect(Store).to.extend Space.messaging.Controller

  it 'is stateful', ->
    expect(Store::get).to.equal Space.ui.Stateful.get
    expect(Store::set).to.equal Space.ui.Stateful.set

  it 'provides aliases for setting and getting state', ->
    expect(Store::getState).to.equal Space.ui.Stateful.get
    expect(Store::setState).to.equal Space.ui.Stateful.set

  it 'sets the state to an empty object by default', ->
    store = new Store()
    store.state = new ReactiveVar()
    store.underscore = _
    store.tracker = Tracker
    store.onDependenciesReady()
    expect(store.get()).to.deep.equal {}
