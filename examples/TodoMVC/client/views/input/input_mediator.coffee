
class @InputMediator extends Space.ui.Mediator

  @toString: -> 'InputMediator'

  Dependencies:
    actions: 'Actions'

  createTodo: (title) -> @dispatch @actions.CREATE_TODO, title