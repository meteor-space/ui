
class @TodoMVC extends Space.ui.Application

  RequiredModules: ['Space.ui']
  Stores: ['TodosStore']
  Mediators: ['TodoListMediator', 'FooterMediator']
  Components: ['InputComponent']
  Controllers: ['IndexController']

  configure: ->
    super()
    # Use iron:router for this example app
    @injector.map('Router').to Router
