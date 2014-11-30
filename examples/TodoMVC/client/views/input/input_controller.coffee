
class @InputController extends Space.ui.ViewController

  @toString: -> 'InputController'

  Dependencies:
    actions: 'Actions'

  createTodo: (title) -> @dispatch @actions.CREATE_TODO, title