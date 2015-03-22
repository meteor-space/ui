
class @TodosController extends Space.messaging.Controller

  Dependencies:
    todos: 'Todos'

  @on ToggleAllTodos, {allowClient: true}, ->
    @todos.update {}, {$set: isCompleted: !@_allTodosCompleted()}, multi: true

  @on ClearCompletedTodos, {allowClient: true}, -> @todos.remove isCompleted: true

  _allTodosCompleted: -> @todos.find(isCompleted: false).count() is 0
