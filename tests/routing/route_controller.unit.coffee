
RouteController = Space.ui.RouteController

describe "#{RouteController}", ->

  beforeEach ->

    @controller = new RouteController()
    sinon.stub @controller, 'mapTemplateToMediator'
    sinon.stub @controller, 'addRoute'

  it 'is a messenger', ->
    expect(@controller).to.be.instanceof Space.ui.Messenger

  it 'configures itself when dependencies are ready.', ->

    sinon.spy @controller, 'configure'
    @controller.dispatcher = register: sinon.spy()

    @controller.onDependenciesReady()

    expect(@controller.configure).to.have.been.calledOnce

  it 'Declares its dependencies correctly.', ->

    expect(RouteController::Dependencies).to.eql {
      templates: 'Template'
      templateMediatorMap: 'Space.ui.TemplateMediatorMap'
      router: 'Space.ui.Router'
    }


  describe '#mapTemplateToMediator', ->

    it 'Maps template to mediator according to given configuration', ->

      controller = new RouteController()

      template = {}
      controller.templates = test_template: template

      mediatorMapping = toMediator: sinon.spy()
      controller.templateMediatorMap = map: sinon.stub().returns mediatorMapping

      fakeMediator = {}

      # ACTION
      controller.mapTemplateToMediator {
        template: 'test_template',
        mediator: fakeMediator
      }

      expect(controller.templateMediatorMap.map).to.have.been.calledWith template
      expect(mediatorMapping.toMediator).to.have.been.calledWith fakeMediator


  describe '#addRoute', ->

    it 'Adds an iron-router route with given configuration', ->

      route =
        name: 'test'
        path: '/test'

      controller = new RouteController()
      controller.router = route: sinon.stub()

      # ACTION
      controller.addRoute route

      expect(controller.router.route).to.have.been.calledWith route.path, route


  describe '#addMediatedRoute', ->

    it 'Maps template to given mediator', ->

      route = template: 'test'
      mediator = {}

      @controller.addMediatedRoute route: route, mediator: mediator

      expect(@controller.mapTemplateToMediator).to.have.been.calledWithMatch(
        template: route.template
        mediator: mediator
      )

    it 'Wires up a route with given configuration', ->

      route = {}
      mediator = {}

      @controller.addMediatedRoute route: route, mediator: mediator

      expect(@controller.addRoute).to.have.been.calledWithExactly route
