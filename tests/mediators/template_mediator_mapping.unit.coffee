Munit.run

  name: 'Space.ui - TemplateMediatorMapping'
  type: 'client'

  tests: [
    {
      name: 'adds itself to the module namespace'

      func: ->

        expect(Space.ui.TemplateMediatorMapping).to.exist
    }

    {
      name: 'constructor - saves references to injector and template'

      func: ->

        injector = { name: 'injector' }
        template = { name: 'template' }

        mapping = new Space.ui.TemplateMediatorMapping template, injector

        expect(mapping.injector).to.equal injector
        expect(mapping.template).to.equal template
    }
  ]

Munit.run

  name: 'Space.ui - TemplateMediatorMapping - #inContext'
  type: 'client'

  setup: ->

    @template = {}

    class @TestMediator
      setup: sinon.spy()
      templateDidRender: sinon.spy()
      destroy: sinon.spy()

    @injectorInstance =
      get: Function
      hasMappingFor: Function

    @injectorMock = sinon.mock @injectorInstance
    @mediatorInstance = new @TestMediator()
    @templateMediatorMapping = new Space.ui.TemplateMediatorMapping @template, @injectorInstance

  tests: [

    {
      name: 'adds context as property on the mapping'

      func: ->

        contextValue = 'Test'
        @templateMediatorMapping.inContext contextValue

        expect(@templateMediatorMapping.context).to.equal contextValue
    }

    {
      name: 'returns the mapping instance'

      func: ->

        returnValue = @templateMediatorMapping.inContext()

        expect(returnValue).to.equal @templateMediatorMapping
    }

  ]


Munit.run

  name: 'Space.ui - TemplateMediatorMapping - #toMediator'
  type: 'client'

  setup: ->

    @template = {}
    @fakeInjector = {}
    @templateMediatorMapping = new Space.ui.TemplateMediatorMapping @template, @fakeInjector

  tests: [
    {
      name: 'adds created callback to the template'

      func: ->

        @templateMediatorMapping.toMediator 'TestMediator'

        expect(@template).to.respondTo 'created'
    }

    {
      name: 'does not add mediator to template right away'

      func: ->

        @templateMediatorMapping.toMediator 'TestMediator'

        expect(@template.mediator).to.be.undefined
    }

    {
      name: 'adds rendered callback to the template'

      func: ->

        @templateMediatorMapping.toMediator 'TestMediator'

        expect(@template).to.respondTo 'rendered'
    }

    {
      name: 'adds destroyed callback to the template'

      func: ->

        @templateMediatorMapping.toMediator 'TestMediator'

        expect(@template).to.respondTo 'destroyed'
    }
  ]

Munit.run

  name: 'Space.ui - TemplateMediatorMapping - #toMediator - createdCallback'
  type: 'client'

  setup: ->

    @template = {}

    class @TestMediator
      templateCreated: sinon.spy()

    @injectorInstance =
      get: Function
      hasMappingFor: Function

    @injectorMock = sinon.mock @injectorInstance
    @mediatorInstance = new @TestMediator()
    @templateMediatorMapping = new Space.ui.TemplateMediatorMapping @template, @injectorInstance

  tests: [

    {
      name: 'adds mediator to template instance'

      func: ->

        @injectorMock.expects('get').once()
                     .withExactArgs('TestMediator')
                     .returns(@mediatorInstance)

        @templateMediatorMapping.toMediator 'TestMediator'

        # simulate Meteor template created callback
        @template.created.call @template

        expect(@template.mediator).to.equal @mediatorInstance
    }

    {
      name: 'saves and calls existing created callback'

      func: ->

        @injectorMock.expects('get').once()
                     .withExactArgs('TestMediator')
                     .returns(@mediatorInstance)

        existingCreatedCallback = sinon.spy()
        @template.created = existingCreatedCallback

        @templateMediatorMapping.toMediator 'TestMediator'

        # simulate Meteor template created callback
        @template.created.call @template

        expect(existingCreatedCallback).to.have.been.calledOn @template
    }

    {
      name: 'mediator is assigned when template context is right'

      func: ->

        @injectorMock.expects('get').once()
                     .withExactArgs('TestMediator')
                     .returns(@mediatorInstance)

        @template.data = templateMediatorContext: 'test'

        @templateMediatorMapping.inContext('test').toMediator 'TestMediator'

        # simulate Meteor template created callback
        @template.created.call @template

        expect(@template.mediator).to.equal @mediatorInstance
    }

    {
      name: 'mediator is not assigned when template context is wrong'

      func: ->

        @injectorMock.expects('get').never()

        @template.data = templateMediatorContext: 'wrong'

        @templateMediatorMapping.inContext('test').toMediator 'TestMediator'

        # simulate Meteor template created callback
        @template.created.call @template

        expect(@template.mediator).to.be.undefined
    }

    {
      name: 'tells the mediator that the template was created'

      func: ->

        @injectorMock.expects('get').once()
                     .withExactArgs('TestMediator')
                     .returns(@mediatorInstance)

        @templateMediatorMapping.toMediator 'TestMediator'

        # simulate Meteor template created callback
        @template.created.call @template

        expect(@mediatorInstance.templateCreated).to.have.been.calledWithExactly @template
    }

    {
      name: 'does not invoke the created callback if mediator has none defined'

      func: ->

        mediatorWithoutTemplateCreatedMethod = {}

        @injectorMock.expects('get').once()
                     .withExactArgs('TestMediator')
                     .returns(mediatorWithoutTemplateCreatedMethod)

        @templateMediatorMapping.toMediator 'TestMediator'

        creatingTemplate = =>
          # simulate Meteor template created callback
          @template.created.call @template

        expect(creatingTemplate).not.to.throw Error
    }
  ]

Munit.run

  name: 'Space.ui - TemplateMediatorMapping - #toMediator - renderedCallback'
  type: 'client'

  setup: ->

    @template = {}
    @fakeMediator = templateRendered: sinon.spy()
    @fakeInjector = {}

    @templateMediatorMapping = new Space.ui.TemplateMediatorMapping @template, @fakeInjector

  tests: [

    {
      name: 'calls the template did render callback on the mediator'

      func: ->

        @templateMediatorMapping.toMediator()

        @template.mediator = @fakeMediator

        # simulate Meteor template created callback
        @template.rendered.call @template

        expect(@fakeMediator.templateRendered).to.have.been.calledWithExactly @template
    }

    {
      name: 'does not invoke the template did render callback if mediator has none defined'

      func: ->

        @templateMediatorMapping.toMediator()

        @template.mediator = {}

        renderingTemplate = =>
          # simulate Meteor template created callback
          @template.rendered.call @template

        expect(renderingTemplate).not.to.throw Error
    }

    {
      name: 'checks if the template has a mediator assigned'

      func: ->

        @templateMediatorMapping.toMediator()

        # simulate Meteor template created callback
        @template.rendered.call @template

        expect(@fakeMediator.templateRendered).not.to.have.been.called
    }

    {
      name: 'saves and calls existing rendered callback'

      func: ->

        existingRenderedCallback = sinon.spy()
        @template.rendered = existingRenderedCallback

        @templateMediatorMapping.toMediator()

        @template.mediator = @fakeMediator

        # simulate Meteor template created callback
        @template.rendered.call @template

        expect(existingRenderedCallback).to.have.been.calledOn @template
    }
  ]

Munit.run

  name: 'Space.ui - TemplateMediatorMapping - #toMediator - destroyCallback'
  type: 'client'

  setup: ->

    @template = {}
    @fakeMediator = templateDestroyed: sinon.spy()
    @fakeInjector = {}

    @templateMediatorMapping = new Space.ui.TemplateMediatorMapping @template, @fakeInjector

  tests: [

    {
      name: 'calls the destroyed callback on the mediator'

      func: ->

        @templateMediatorMapping.toMediator()

        @template.mediator = @fakeMediator

        # simulate Meteor template created callback
        @template.destroyed.call @template

        expect(@fakeMediator.templateDestroyed).to.have.been.calledWithExactly @template
    }

    {
      name: 'does not invoke the destroyed callback if mediator has none defined'

      func: ->

        @templateMediatorMapping.toMediator()

        @template.mediator = {}

        destroyTemplate = =>
          # simulate Meteor template created callback
          @template.destroyed.call @template

        expect(destroyTemplate).not.to.throw Error
    }

    {
      name: 'checks if the template has a mediator assigned'

      func: ->

        @templateMediatorMapping.toMediator()

        # simulate Meteor template created callback
        @template.destroyed.call @template

        expect(@fakeMediator.templateDestroyed).not.to.have.been.called
    }

    {
      name: 'saves and calls existing rendered callback'

      func: ->

        existingDestroyedCallback = sinon.spy()
        @template.destroyed = existingDestroyedCallback

        @templateMediatorMapping.toMediator()

        @template.mediator = @fakeMediator

        # simulate Meteor template created callback
        @template.destroyed.call @template

        expect(existingDestroyedCallback).to.have.been.calledOn @template
    }
  ]
