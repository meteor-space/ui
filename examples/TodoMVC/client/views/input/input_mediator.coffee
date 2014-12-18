
class TodoMVC.InputMediator extends Space.ui.Mediator

  @Template: 'input'

  Dependencies:
    actions: 'Actions'

  templateEvents: ->

    'keyup #new-todo': (event, template) =>

      # on ENTER key
      if event.keyCode is 13

        # create todo
        @actions.createTodo template.$('#new-todo').val()

        # reset input
        template.$('#new-todo').val('')