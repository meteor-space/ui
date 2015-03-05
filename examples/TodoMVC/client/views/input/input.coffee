
Template.input.events

  'keyup #new-todo': (event, template) ->

    # When it was the ENTER key
    if event.keyCode is 13
      # Tell mediator about it
      input = template.$('#new-todo').val()
      template.mediator.onInputSubmitted input
      # Reset input
      template.$('#new-todo').val('')
