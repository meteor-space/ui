
class TodoMVC.TodosStore extends Space.ui.Store

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  Dependencies:
    todos: 'TodoMVC.Todos'

  reactiveVars: -> [
    activeFilter: @FILTERS.ALL
  ]

  filteredTodos: ->
    switch @activeFilter()
      when @FILTERS.ALL then return @todos.find()
      when @FILTERS.ACTIVE then return @todos.find isCompleted: false
      when @FILTERS.COMPLETED then return @todos.find isCompleted: true

  completedTodos: -> @todos.find isCompleted: true

  activeTodos: -> @todos.find isCompleted: false

  @on TodoMVC.TodoCreated, (event) -> @todos.insert title: event.title, isCompleted: false

  @on TodoMVC.TodoDeleted, (event) -> @todos.remove event.todoId

  @on TodoMVC.TodoTitleChanged, (event) -> @todos.update event.todoId, $set: title: event.newTitle

  @on TodoMVC.TodoToggled, (event) ->
    isCompleted = @todos.findOne(event.todoId).isCompleted
    @todos.update event.todoId, $set: isCompleted: !isCompleted

  @on TodoMVC.FilterChanged, (event) -> @activeFilter event.filter
