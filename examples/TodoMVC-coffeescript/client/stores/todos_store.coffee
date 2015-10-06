
class TodoMVC.TodosStore extends Space.ui.Store

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  Dependencies:
    todos: 'TodoMVC.Todos'

  setDefaultState: -> {
    activeFilter: @FILTERS.ALL
  }

  setReactiveState: -> {
    todos: @todos.find()
    completedTodos: @todos.find isCompleted: true
    activeTodos: @todos.find isCompleted: false
  }

  @on TodoMVC.TodoCreated, (event) -> @todos.insert title: event.title, isCompleted: false

  @on TodoMVC.TodoDeleted, (event) -> @todos.remove event.todoId

  @on TodoMVC.TodoTitleChanged, (event) -> @todos.update event.todoId, $set: title: event.newTitle

  @on TodoMVC.TodoToggled, (event) ->
    isCompleted = @todos.findOne(event.todoId).isCompleted
    @todos.update event.todoId, $set: isCompleted: !isCompleted

  @on TodoMVC.FilterChanged, (event) ->

    # only continue if it actually changed
    if @get('activeFilter') is event.filter then return

    switch event.filter

      when @FILTERS.ALL then @set 'todos', @todos.find()
      when @FILTERS.ACTIVE then @set 'todos', @todos.find isCompleted: false
      when @FILTERS.COMPLETED then @set 'todos', @todos.find isCompleted: true

      else return # only accept valid options

    @set 'activeFilter', event.filter
