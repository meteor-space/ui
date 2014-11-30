
ENTER_KEY = 13

Template.input.events

  'keyup #new-todo': (event, template) ->

    input = template.$('#new-todo')

    if event.keyCode is ENTER_KEY
      template.mediator.createTodo input.val()
      input.val ''