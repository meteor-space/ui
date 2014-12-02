
class @TodoMVC extends Space.Application

  RequiredModules: ['Space.ui']

  Dependencies:
    mongo: 'Mongo'
    templates: 'Template'
    templateMediatorMap: 'Space.ui.TemplateMediatorMap'

  configure: ->

    # DATA + LOGIC
    @injector.map('Todos').toStaticValue new @mongo.Collection 'todos'
    @injector.map('Actions').toStaticValue ACTIONS
    @injector.map(TodosStore).asSingleton()

    # ROUTING
    @injector.map(IndexController).asSingleton()

    # VIEWS
    @injector.map(TodoListMediator).asSingleton()
    @injector.map(InputMediator).asSingleton()
    @injector.map(FooterMediator).asSingleton()

    @templateMediatorMap.map(@templates.todo_list).toMediator TodoListMediator
    @templateMediatorMap.map(@templates.input).toMediator InputMediator
    @templateMediatorMap.map(@templates.footer).toMediator FooterMediator

  run: ->
    @injector.create TodosStore
    @injector.create IndexController # start routing
