
{Mediator} = Space.ui

describe 'Space.ui.Mediator', ->

  beforeEach ->
    @mediator = new Mediator()

  describe 'publishing events', ->

    it 'hands the event over to the event store', ->
      @mediator.eventBus = publish: sinon.spy()
      testEvent = {}
      @mediator.publish testEvent

      expect(@mediator.eventBus.publish).to.have.been.calledWith testEvent
