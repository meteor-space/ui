
class @TodosStore extends Space.ui.Store

  Dependencies:
    todos: 'Todos'

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  setInitialState: ->
    todos: @todos.find()
    completedTodos: @todos.find isCompleted: true
    activeTodos: @todos.find isCompleted: false
    activeFilter: @FILTERS.ALL

  @handle TodoCreated, on: (event) ->
    @todos.insert title: event.title, isCompleted: false

  @handle TodoDeleted, on: (event) -> @todos.remove event.todoId

  @handle TodoTitleChanged, on: (event) ->
    @todos.update event.todoId, $set: title: event.newTitle

  @handle TodoToggled, on: (event) ->
    isCompleted = @todos.findOne(event.todoId).isCompleted
    @todos.update event.todoId, $set: isCompleted: !isCompleted

  @handle AllTodosToggled, on: -> @commandBus.send new ToggleAllTodos()

  @handle CompletedTodosCleared, on: -> @commandBus.send new ClearCompletedTodos()

  @handle FilterChanged, on: (event) ->

    # only continue if it changed
    if @get('activeFilter') is event.filter then return

    switch event.filter

      when @FILTERS.ALL then @set 'todos', @todos.find()
      when @FILTERS.ACTIVE then @set 'todos', @todos.find isCompleted: false
      when @FILTERS.COMPLETED then @set 'todos', @todos.find isCompleted: true

      else return # only accept valid options

    @set 'activeFilter', event.filter
