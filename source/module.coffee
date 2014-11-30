
class Space.ui extends Space.Module

  @publish this, 'Space.ui'

  Dependencies:
    meteor: 'Meteor'

  configure: ->

    # map public api of iron-router
    @injector.map('Space.ui.Router').toStaticValue Router
    @injector.map('Space.ui.RouteController').toStaticValue RouteController

    # map public api of fast-render
    @injector.map('Space.ui.FastRender').toStaticValue FastRender

    if @meteor.isClient

      @injector.map('Space.ui.ReactiveProperty').toClass ReactiveVar
      @injector.map('Space.ui.History').toStaticValue history

      @injector.map(Space.ui.Dispatcher).asSingleton()
      @injector.map(Space.ui.TemplateMediatorMap).asSingleton()