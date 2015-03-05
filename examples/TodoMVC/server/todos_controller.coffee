
class @TodosController extends Space.messaging.Controller

  Dependencies:
    todos: 'Todos'

  @handle ToggleAllTodos, allowClient: true, on: (command) ->

    if @todos.find(isCompleted: false).count() is 0 # all todos completed
      @todos.update {}, { $set: isCompleted: false }, multi: true
    else
      @todos.update {}, { $set: isCompleted: true }, multi: true

  @handle ClearCompletedTodos, allowClient: true, on: (command) ->

    @todos.remove isCompleted: true
