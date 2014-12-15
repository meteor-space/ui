
class TodoMVC.InputMediator extends Space.ui.Mediator

  @Template: 'input'

  Dependencies:
    actions: 'Actions'

  templateEvents: ->

    'keyup #new-todo': (event, template) =>

      input = template.$ '#new-todo'

      # on ENTER key
      if event.keyCode is 13

        # create todo
        @actions.createTodo input.val()

        # reset input
        input.val ''