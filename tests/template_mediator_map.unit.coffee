
describe 'Space.ui.TemplateMediatorMap', ->

  it 'adds itself to the module namespace', ->

    expect(Space.ui.TemplateMediatorMap).to.exist

  describe 'construction', ->

    it 'saves reference to given injector instance', ->

      fakeInjector = {}
      map = new Space.ui.TemplateMediatorMap fakeInjector
      expect(map.injector).to.equal fakeInjector

  describe '#map', ->

    it 'creates and returns configured template mapping', ->

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
