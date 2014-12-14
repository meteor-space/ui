
class TodoMVC.InputMediator extends Space.ui.Mediator

  @Template: 'input'

  Dependencies:
    actions: 'Actions'

  createTodo: (title) -> @actions.createTodo title