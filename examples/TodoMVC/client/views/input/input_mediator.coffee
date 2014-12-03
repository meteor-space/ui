
class TodoMVC.InputMediator extends Space.ui.Mediator

  Dependencies:
    actions: 'Actions'

  createTodo: (title) -> @dispatch @actions.CREATE_TODO, title