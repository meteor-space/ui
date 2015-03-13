
class Space.ui.Application extends Space.Application

  Stores: []
  Mediators: []
  Controllers: []

  Dependencies:
    templates: 'Space.ui.TemplateMediatorMap'

  configure: ->
    @templates.autoMap mediator for mediator in @Mediators
    @injector.map(store).asSingleton() for store in @Stores
    @injector.map(controller).asSingleton() for controller in @Controllers

  run: ->
    @injector.create(store) for store in @Stores
    @injector.create(controller) for controller in @Controllers
