
class @TodoMVC extends Space.Application

  RequiredModules: ['Space.messaging']
  Singletons: [
    'TodoMVC.TodosApi'
    'TodoMVC.TodosPublication'
  ]
