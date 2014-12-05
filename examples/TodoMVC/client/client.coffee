
class TodoMVC.Application extends Space.Application

  RequiredModules: ['Space.ui']

  Dependencies:
    mongo: 'Mongo'
    templates: 'Template'
    templateMediatorMap: 'Space.ui.TemplateMediatorMap'

  configure: ->

    # DATA + LOGIC
    @injector.map('Todos').toStaticValue new @mongo.Collection 'todos'
    @injector.map('Actions').toStaticValue TodoMVC.ACTIONS
    @injector.map('TodosStore').toSingleton TodoMVC.TodosStore

    # ROUTING
    @injector.map('IndexController').toSingleton TodoMVC.IndexController

    # TEMPLATE MEDIATORS
    @templateMediatorMap.autoMap 'TodoListMediator', TodoMVC.TodoListMediator
    @templateMediatorMap.autoMap 'InputMediator', TodoMVC.InputMediator
    @templateMediatorMap.autoMap 'FooterMediator', TodoMVC.FooterMediator

  run: ->
    @injector.create 'TodosStore'
    @injector.create 'IndexController' # start routing
