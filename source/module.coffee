
class Space.ui extends Space.Module

  @publish this, 'Space.ui'

  RequiredModules: ['Space.messaging']

  configure: -> @injector.map('Space.ui.TemplateMediatorMap').asSingleton()
