
class @TodoMVC extends Space.Application

  RequiredModules: ['Space.messaging']

  Dependencies:
    meteor: 'Meteor'
    mongo: 'Mongo'

  configure: ->
    super
    @injector.map('Todos').to new @mongo.Collection 'todos'
    @injector.map('TodosController').asSingleton()

  run: ->
    super
    @injector.create 'TodosController'
