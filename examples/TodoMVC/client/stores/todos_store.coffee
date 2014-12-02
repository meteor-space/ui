
class @TodosStore extends Space.ui.Store

  @toString: -> 'TodosStore'

  Dependencies:
    todosCollection: 'TodosCollection'
    actions: 'Actions'
    meteor: 'Meteor'

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  onDependenciesReady: ->
    @todos = @todosCollection.get()
    super()

  setInitialState: -> {
    todos: @todos.find()
    completedTodos: @todos.find isCompleted: true
    activeTodos: @todos.find isCompleted: false
    activeFilter: @FILTERS.ALL
  }

  configure: ->

    @bindActions(
      @actions.TOGGLE_TODO, '_toggleTodo'
      @actions.CREATE_TODO, '_createTodo'
      @actions.DESTROY_TODO, '_destroyTodo'
      @actions.CHANGE_TODO_TITLE, '_changeTodoTitle'
      @actions.TOGGLE_ALL_TODOS, '_toggleAll'
      @actions.CLEAR_COMPLETED_TODOS, '_clearCompleted'
      @actions.SET_FILTER, '_setFilter'
    )

  _toggleTodo: (todo) -> @todos.update todo._id, $set: isCompleted: !todo.isCompleted

  _createTodo: (title) -> @todos.insert title: title, isCompleted: false

  _destroyTodo: (todo) -> @todos.remove todo._id

  _changeTodoTitle: (data) -> @todos.update data.todo._id, $set: title: data.newTitle

  _toggleAll: -> @meteor.call 'toggleAllTodos'

  _clearCompleted: -> @meteor.call 'clearCompletedTodos'

  _setFilter: (filter) ->

    # only continue if it changed
    if @getState('activeFilter') is filter then return

    switch filter

      when @FILTERS.ALL then @setState 'todos', @todos.find()
      when @FILTERS.ACTIVE then @setState 'todos', @todos.find isCompleted: false
      when @FILTERS.COMPLETED then @setState 'todos', @todos.find isCompleted: true

      else return # only accept valid options

    @setState 'activeFilter', filter
