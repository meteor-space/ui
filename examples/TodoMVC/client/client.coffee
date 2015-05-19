
class @TodoMVC extends Space.ui.Application

  RequiredModules: ['Space.ui']
  Stores: ['TodosStore']
  Mediators: ['TodoListMediator']
  Components: ['InputComponent', 'FooterComponent']
  Controllers: ['IndexController']

  configure: ->
    super()
    # Use iron:router for this example app
    @injector.map('Router').to Router
