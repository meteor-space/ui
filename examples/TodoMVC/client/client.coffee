
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

    # VIEWS
    @injector.map('TodoListMediator').toSingleton TodoMVC.TodoListMediator
    @injector.map('InputMediator').toSingleton TodoMVC.InputMediator
    @injector.map('FooterMediator').toSingleton TodoMVC.FooterMediator

    @templateMediatorMap.map(@templates.todo_list).toMediator 'TodoListMediator'
    @templateMediatorMap.map(@templates.input).toMediator 'InputMediator'
    @templateMediatorMap.map(@templates.footer).toMediator 'FooterMediator'

  run: ->
    @injector.create 'TodosStore'
    @injector.create 'IndexController' # start routing
