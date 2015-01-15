
class TodoMVC.Application extends Space.Application

  RequiredModules: ['Space.ui']

  Dependencies:
    mongo: 'Mongo'
    templateMediatorMap: 'Space.ui.TemplateMediatorMap'
    actionFactory: 'Space.ui.ActionFactory'

  configure: ->

    # ACTIONS
    @injector.map('Actions').toStaticValue @actionFactory.create [
      'toggleTodo'
      'createTodo'
      'destroyTodo'
      'changeTodoTitle'
      'toggleAllTodos'
      'clearCompletedTodos'
      'setTodosFilter'
    ]

    # DATA + LOGIC
    @injector.map('Todos').toStaticValue new @mongo.Collection 'todos'
    @injector.map('TodosStore').toSingleton TodoMVC.TodosStore

    # IRON ROUTER
    @injector.map('Router').toStaticValue Router
    @injector.map('IndexController').toSingleton TodoMVC.IndexController

    # TEMPLATE MEDIATORS
    @templateMediatorMap.autoMap 'TodoListMediator', TodoMVC.TodoListMediator
    @templateMediatorMap.autoMap 'InputMediator', TodoMVC.InputMediator
    @templateMediatorMap.autoMap 'FooterMediator', TodoMVC.FooterMediator

  run: ->
    @injector.create 'TodosStore'
    @injector.create 'IndexController' # start routing
