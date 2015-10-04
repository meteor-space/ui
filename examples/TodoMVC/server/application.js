
TodoMVC = Space.Application.extend('TodoMVC', {
  RequiredModules: ['Space.messaging'],
  Singletons: [
    'TodoMVC.TodosApi',
    'TodoMVC.TodosPublication'
  ]
});
