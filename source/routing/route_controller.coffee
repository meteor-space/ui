
class Space.ui.RouteController extends Space.ui.ActionHandler

  @toString: -> 'Space.ui.RouteController'

  Dependencies:
    templates: 'Template'
    templateMediatorMap: 'Space.ui.TemplateMediatorMap'
    router: 'Space.ui.Router'

  onDependenciesReady: ->
    super()
    @configure()

  configure: ->

  mapTemplateToMediator: (mapping) ->
    template = @templates[mapping.template]
    @templateMediatorMap.map(template).toMediator mapping.mediator

  addRoute: (route) -> @router.route route.path, route

  addMediatedRoute: (config) ->

    @mapTemplateToMediator
      template: config.route.template
      mediator: config.mediator

    @addRoute config.route

  visit: (route, data) -> @router.go route.name, data