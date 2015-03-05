Munit.run

  name: 'Space.ui - TemplateMediatorMap'
  type: 'client'

  tests: [
    {
      name: 'adds itself to the module namespace'

      func: -> expect(Space.ui.TemplateMediatorMap).to.exist
    }

    {
      name: 'constructor - saves reference to given injector instance'

      func: ->

        fakeInjector = {}
        map = new Space.ui.TemplateMediatorMap fakeInjector

        expect(map.injector).to.equal fakeInjector
    }

    {
      name: '#map - creates and returns configured template mapping'

      func: ->

        fakeTemplate = {}
        fakeInjector = {}
        fakeMappingInstance = {}

        mappingClassStub = sinon.stub Space.ui, 'TemplateMediatorMapping'
        mappingClassStub.returns fakeMappingInstance

        testMap = new Space.ui.TemplateMediatorMap fakeInjector

        returnValue = testMap.map fakeTemplate

        expect(returnValue).to.equal fakeMappingInstance
        expect(mappingClassStub).to.have.been.calledWithNew
        expect(mappingClassStub).to.have.been.calledWithExactly fakeTemplate, fakeInjector

        mappingClassStub.restore()
    }
  ]
