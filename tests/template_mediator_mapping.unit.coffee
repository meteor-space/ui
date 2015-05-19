
describe 'Space.ui.TemplateMediatorMapping', ->

  class TestMediator
    templateCreated: sinon.spy()
    templateRendered: sinon.spy()
    templateDestroyed: sinon.spy()

  beforeEach ->
    @template = {}
    @injector =
      get: Function
      hasMappingFor: Function
    @injectorMock = sinon.mock @injector
    @mediator = new TestMediator()
    @mapping = new Space.ui.TemplateMediatorMapping @template, @injector

    # Setup expecations
    @injectorMock.expects('get').withArgs('TestMediator').returns(@mediator)

  describe 'construction', ->

    it 'saves references to injector and template', ->

      injector = { name: 'injector' }
      template = { name: 'template' }

      mapping = new Space.ui.TemplateMediatorMapping template, injector

      expect(mapping.injector).to.equal injector
      expect(mapping.template).to.equal template

  describe '#toMediator', ->

    it 'adds created callback to the template', ->
      @mapping.toMediator 'TestMediator'
      expect(@template).to.respondTo 'created'

    it 'does not add mediator to template right away', ->
      @mapping.toMediator 'TestMediator'
      expect(@template.mediator).to.be.undefined

    it 'adds rendered callback to the template', ->
      @mapping.toMediator 'TestMediator'
      expect(@template).to.respondTo 'rendered'

    it 'adds destroyed callback to the template', ->
      @mapping.toMediator 'TestMediator'
      expect(@template).to.respondTo 'destroyed'

    describe 'createdCallback', ->

      it 'adds mediator to template instance', ->

        @mapping.toMediator 'TestMediator'
        # simulate Meteor template created callback
        @template.created.call @template
        expect(@template.mediator).to.equal @mediator

      it 'saves and calls existing created callback', ->

        existingCreatedCallback = sinon.spy()
        @template.created = existingCreatedCallback
        @mapping.toMediator 'TestMediator'
        # simulate Meteor template created callback
        @template.created.call @template
        expect(existingCreatedCallback).to.have.been.calledOn @template

      it 'tells the mediator that the template was created', ->

        @mapping.toMediator 'TestMediator'
        # simulate Meteor template created callback
        @template.created.call @template
        expect(@mediator.templateCreated).to.have.been.calledWith @template

    describe 'renderedCallback', ->

      it 'calls the template did render callback on the mediator', ->
        @mapping.toMediator 'TestMediator'
        @template.mediator = @mediator
        # simulate Meteor template created callback
        @template.rendered.call @template
        expect(@mediator.templateRendered).to.have.been.calledWith @template

      it 'saves and calls existing rendered callback', ->

        # Simulate existing rendered callback
        existingRenderedCallback = sinon.spy()
        @template.rendered = existingRenderedCallback

        @mapping.toMediator 'TestMediator'
        @template.mediator = @mediator

        # simulate Meteor template created callback
        @template.rendered.call @template
        expect(existingRenderedCallback).to.have.been.calledOn @template

    describe 'destroyedCallback', ->

      it 'calls the destroyed callback on the mediator', ->
        @mapping.toMediator 'TestMediator'
        @template.mediator = @mediator
        # simulate Meteor template created callback
        @template.destroyed.call @template
        expect(@mediator.templateDestroyed).to.have.been.calledWith @template

      it 'saves and calls existing destroyed callback', ->

        # Simulate existing rendered callback
        existingDestroyedCallback = sinon.spy()
        @template.destroyed = existingDestroyedCallback

        @mapping.toMediator 'TestMediator'
        @template.mediator = @mediator

        # simulate Meteor template created callback
        @template.destroyed.call @template
        expect(existingDestroyedCallback).to.have.been.calledOn @template

    describe 'Meteor > 1.0 compatibility', ->

      addCallbackStyleStubs = ->
        @template.onCreated = sinon.stub()
        @template.onRendered = sinon.stub()
        @template.onDestroyed = sinon.stub()
        @template.onCreated.callsArgOn 0, @template

      it 'uses the onCreated callback style if available', ->
        addCallbackStyleStubs.call this
        @mapping.toMediator 'TestMediator'
        expect(@template.mediator).to.equal @mediator
        expect(@mediator.templateCreated).to.have.been.calledWith @template

      it 'uses the onRendered callback style if available', ->
        addCallbackStyleStubs.call this
        @template.onRendered.callsArgOn 0, @template
        @mapping.toMediator 'TestMediator'
        expect(@mediator.templateRendered).to.have.been.calledWith @template

      it 'uses the onDestroyed callback style if available', ->
        addCallbackStyleStubs.call this
        @template.onDestroyed.callsArgOn 0, @template
        @mapping.toMediator 'TestMediator'
        expect(@template.mediator).not.to.exist
        expect(@mediator.templateDestroyed).to.have.been.calledWith @template
