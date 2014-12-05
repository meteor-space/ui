
class TodoMVC.InputMediator extends Space.ui.Mediator

  @Template: 'input'

  Dependencies:
    actions: 'Actions'

  createTodo: (title) -> @dispatch @actions.CREATE_TODO, title