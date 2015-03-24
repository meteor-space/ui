
{Mediator} = Space.ui

describe 'Space.ui.Mediator', ->

  beforeEach -> @mediator = new Mediator()

  it 'is stateful', ->
    expect(Mediator::get).to.equal Space.ui.Stateful.get
    expect(Mediator::set).to.equal Space.ui.Stateful.set

  it 'sets the state to an empty object by default', ->
    mediator = new Mediator()
    mediator.state = new ReactiveVar()
    mediator.underscore = _
    mediator.tracker = Tracker
    mediator.onDependenciesReady()
    expect(mediator.get()).to.deep.equal {}

  describe 'publishing events', ->

    it 'hands the event over to the event store', ->
      @mediator.eventBus = publish: sinon.spy()
      testEvent = {}
      @mediator.publish testEvent
      expect(@mediator.eventBus.publish).to.have.been.calledWith testEvent
