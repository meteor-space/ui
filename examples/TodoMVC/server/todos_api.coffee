
class @TodosApi extends Space.messaging.Api

  @method 'toggleAllTodos', ->
    Todos.update {}, {$set: isCompleted: !@_allTodosCompleted()}, multi: true

  @method 'clearCompletedTodos', -> Todos.remove isCompleted: true

  _allTodosCompleted: -> Todos.find(isCompleted: false).count() is 0
