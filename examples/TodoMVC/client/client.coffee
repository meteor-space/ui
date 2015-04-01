
class @TodoMVC extends Space.ui.Application

  RequiredModules: ['Space.ui']
  Stores: ['TodosStore']
  Mediators: ['InputMediator', 'TodoListMediator', 'FooterMediator']
  Controllers: ['IndexController']

  configure: ->
    super
    @injector.map('Router').to Router # Use iron:router for this example app
