
class @TodosStore extends Space.ui.Store

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  setInitialState: ->
    todos: Todos.find()
    completedTodos: Todos.find isCompleted: true
    activeTodos: Todos.find isCompleted: false
    activeFilter: @FILTERS.ALL

  @on TodoCreated, (event) -> Todos.insert title: event.title, isCompleted: false

  @on TodoDeleted, (event) -> Todos.remove event.todoId

  @on TodoTitleChanged, (event) -> Todos.update event.todoId, $set: title: event.newTitle

  @on TodoToggled, (event) ->
    isCompleted = Todos.findOne(event.todoId).isCompleted
    Todos.update event.todoId, $set: isCompleted: !isCompleted

  @on FilterChanged, (event) ->

    # only continue if it actually changed
    if @get('activeFilter') is event.filter then return

    switch event.filter

      when @FILTERS.ALL then @set 'todos', Todos.find()
      when @FILTERS.ACTIVE then @set 'todos', Todos.find isCompleted: false
      when @FILTERS.COMPLETED then @set 'todos', Todos.find isCompleted: true

      else return # only accept valid options

    @set 'activeFilter', event.filter
