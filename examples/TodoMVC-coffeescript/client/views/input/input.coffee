
class @Input extends Space.ui.BlazeComponent

  @register 'input'

  events: -> [
    'keyup #new-todo': (event) ->
      # When it was the ENTER key
      if event.keyCode is 13
        # Tell mediator about it
        input = @$('#new-todo').val()
        @publish new TodoCreated title: input
        # Reset input
        @$('#new-todo').val('')
  ]
