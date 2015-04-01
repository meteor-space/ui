
class @TodoMVC extends Space.Application

  RequiredModules: ['Space.messaging']

  configure: ->
    super
    @injector.map('TodosController').asSingleton()

  run: ->
    super
    @injector.create 'TodosController'
