
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
    @injector.map(TodoListController).asSingleton()
    @injector.map(InputController).asSingleton()
    @injector.map(FooterController).asSingleton()

    @templateMediatorMap.map(@templates.todo_list).toMediator TodoListController
    @templateMediatorMap.map(@templates.input).toMediator InputController
    @templateMediatorMap.map(@templates.footer).toMediator FooterController

  run: ->
    @injector.create TodosStore
    @injector.create IndexController # start routing
