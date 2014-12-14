
class Space.ui extends Space.Module

  @publish this, 'Space.ui'

  Dependencies:
    meteor: 'Meteor'

  configure: ->

    # map public api of iron-router
    @injector.map('Space.ui.Router').toStaticValue Router
    @injector.map('Space.ui.RouteController').toStaticValue RouteController

    if @meteor.isClient

      @injector.map(Space.ui.Dispatcher).asSingleton()
      @injector.map(Space.ui.TemplateMediatorMap).asSingleton()
      @injector.map(Space.ui.ActionFactory).asSingleton()