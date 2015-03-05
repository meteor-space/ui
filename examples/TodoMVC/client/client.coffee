
class @TodoMVC extends Space.Application

  RequiredModules: ['Space.ui']

  Dependencies:
    mongo: 'Mongo'
    templates: 'Space.ui.TemplateMediatorMap'

  configure: ->

    # DATA + LOGIC
    @injector.map('Todos').toStaticValue new @mongo.Collection 'todos'
    @injector.map('TodosStore').toSingleton TodosStore

    # ROUTING WITH IRON-ROUTER
    @injector.map('Router').toStaticValue Router
    @injector.map('IndexController').toSingleton IndexController

    # DEFINE HOW MEDIATORS ARE CREATED
    @injector.map('InputMediator').asSingleton()
    @injector.map('TodoListMediator').asSingleton()
    @injector.map('FooterMediator').asSingleton()

    # MAP TEMPLATES TO MEDIATORS
    @templates.map(Template['todo_list']).toMediator 'TodoListMediator'
    @templates.map(Template['input']).toMediator 'InputMediator'
    @templates.map(Template['footer']).toMediator 'FooterMediator'

  run: ->
    @injector.create 'TodosStore'
    @injector.create 'IndexController' # start routing
