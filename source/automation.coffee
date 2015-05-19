
class Space.ui.Module extends Space.Module
class Space.ui.Application extends Space.Application

automatedMappings =
  Stores: []
  Mediators: []
  Controllers: []
  Components: []

  Dependencies:
    templates: 'Space.ui.TemplateMediatorMap'

  configure: ->
    @templates.autoMap mediator for mediator in @Mediators
    @injector.map(store).asSingleton() for store in @Stores
    @injector.map(controller).asSingleton() for controller in @Controllers
    for componentPath in @Components
      component = Space.resolvePath componentPath
      component.Application = @app

  startup: ->
    @injector.create(store) for store in @Stores
    @injector.create(controller) for controller in @Controllers

_.extend Space.ui.Module.prototype, automatedMappings
_.extend Space.ui.Application.prototype, automatedMappings
