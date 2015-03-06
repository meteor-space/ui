
class @TodoMVC extends Space.Application

  RequiredModules: ['Space.ui']

  Dependencies:
    mongo: 'Mongo'
    templates: 'Space.ui.TemplateMediatorMap'

  configure: ->

    # DATA + LOGIC
    @injector.map('Todos').to new @mongo.Collection 'todos'
    @injector.map('TodosStore').toSingleton TodosStore

    # ROUTING WITH IRON-ROUTER
    @injector.map('Router').to Router
    @injector.map('IndexController').toSingleton IndexController

    # MAP MEDIATORS TO THEIR TEMPLATES
    @templates.autoMap 'InputMediator'
    @templates.autoMap 'TodoListMediator'
    @templates.autoMap 'FooterMediator'

  run: ->
    @injector.create 'TodosStore'
    @injector.create 'IndexController' # start routing
