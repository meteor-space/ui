
class Space.ui extends Space.Module

  @publish this, 'Space.ui'

  Dependencies:
    meteor: 'Meteor'

  configure: ->

    if @meteor.isClient

      @injector.map(Space.ui.Dispatcher).asSingleton()
      @injector.map(Space.ui.TemplateMediatorMap).asSingleton()
      @injector.map(Space.ui.ActionFactory).asSingleton()
