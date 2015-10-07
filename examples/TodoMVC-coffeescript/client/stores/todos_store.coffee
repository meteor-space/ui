
class TodoMVC.TodosStore extends Space.ui.Store

  Dependencies:
    todos: 'TodoMVC.Todos'

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  reactiveVars: -> [
    activeFilter: @FILTERS.ALL
    editingTodoId: null
  ]

  filteredTodos: ->
    switch @activeFilter()
      when @FILTERS.ALL then return @todos.find()
      when @FILTERS.ACTIVE then return @todos.find isCompleted: false
      when @FILTERS.COMPLETED then return @todos.find isCompleted: true

  completedTodos: -> @todos.find isCompleted: true

  activeTodos: -> @todos.find isCompleted: false

  events: -> [

    'TodoMVC.TodoCreated': (event) -> @todos.insert {
      title: event.title, isCompleted: false
    }

    'TodoMVC.TodoDeleted': (event) -> @todos.remove event.todoId

    'TodoMVC.TodoEditingStarted': (event) -> @editingTodoId event.todoId

    'TodoMVC.TodoEditingEnded': (event) -> @editingTodoId null

    'TodoMVC.TodoTitleChanged': (event) -> @todos.update event.todoId, {
      $set: title: event.newTitle
    }

    'TodoMVC.TodoToggled': (event) ->
      isCompleted = @todos.findOne(event.todoId).isCompleted
      @todos.update event.todoId, $set: isCompleted: !isCompleted

    'TodoMVC.FilterChanged': (event) -> @activeFilter event.filter
  ]
