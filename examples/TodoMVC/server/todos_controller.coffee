
class @TodosController extends Space.messaging.Controller

  @on ToggleAllTodos, {allowClient: true}, ->
    Todos.update {}, {$set: isCompleted: !@_allTodosCompleted()}, multi: true

  @on ClearCompletedTodos, {allowClient: true}, -> Todos.remove isCompleted: true

  _allTodosCompleted: -> Todos.find(isCompleted: false).count() is 0
