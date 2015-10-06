
class TodoMVC.TodosApi extends Space.messaging.Api

  Dependencies:
    todos: 'TodoMVC.Todos'

  @method 'toggleAllTodos', ->
    @todos.update {}, {$set: isCompleted: !@_allTodosCompleted()}, multi: true

  @method 'clearCompletedTodos', -> @todos.remove isCompleted: true

  _allTodosCompleted: -> @todos.find(isCompleted: false).count() is 0
