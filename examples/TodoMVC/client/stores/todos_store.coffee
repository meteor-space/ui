
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

  @on TodoCreated, (event) -> @todos.insert title: event.title, isCompleted: false

  @on TodoDeleted, (event) -> @todos.remove event.todoId

  @on TodoTitleChanged, (event) -> @todos.update event.todoId, $set: title: event.newTitle

  @on TodoToggled, (event) ->
    isCompleted = @todos.findOne(event.todoId).isCompleted
    @todos.update event.todoId, $set: isCompleted: !isCompleted

  @on AllTodosToggled, -> @commandBus.send new ToggleAllTodos()

  @on CompletedTodosCleared, -> @commandBus.send new ClearCompletedTodos()

  @on FilterChanged, (event) ->

    # only continue if it actually changed
    if @get('activeFilter') is event.filter then return

    switch event.filter

      when @FILTERS.ALL then @set 'todos', @todos.find()
      when @FILTERS.ACTIVE then @set 'todos', @todos.find isCompleted: false
      when @FILTERS.COMPLETED then @set 'todos', @todos.find isCompleted: true

      else return # only accept valid options

    @set 'activeFilter', event.filter
