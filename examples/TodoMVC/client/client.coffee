
class @TodoMVC extends Space.Application

  RequiredModules: ['Space.ui']

  Dependencies:
    templates: 'Template'
    templateMediatorMap: 'Space.ui.TemplateMediatorMap'

  configure: ->

    # DATA + LOGIC
    @injector.map(TodosCollection).asSingleton()
    @injector.map(TodosStore).asSingleton()
    @injector.map('Actions').toStaticValue ACTIONS

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
