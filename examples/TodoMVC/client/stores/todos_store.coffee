
class TodoMVC.TodosStore extends Space.ui.Store

  Dependencies:
    todos: 'Todos'
    actions: 'Actions'
    meteor: 'Meteor'

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  setInitialState: -> {
    todos: @todos.find()
    completedTodos: @todos.find isCompleted: true
    activeTodos: @todos.find isCompleted: false
    activeFilter: @FILTERS.ALL
  }

  configure: ->

    @listenTo(
      @actions.toggleTodo, @_toggleTodo
      @actions.createTodo, @_createTodo
      @actions.destroyTodo, @_destroyTodo
      @actions.changeTodoTitle, @_changeTodoTitle
      @actions.toggleAllTodos, @_toggleAllTodos
      @actions.clearCompletedTodos, @_clearCompletedTodos
      @actions.setTodosFilter, @_setTodosFilter
    )

  _createTodo: (title) -> @todos.insert title: title, isCompleted: false

  _destroyTodo: (todo) -> @todos.remove todo._id

  _changeTodoTitle: (data) -> @todos.update data.todo._id, $set: title: data.newTitle

  _toggleTodo: (todo) -> @todos.update todo._id, $set: isCompleted: !todo.isCompleted

  _toggleAllTodos: -> @meteor.call 'toggleAllTodos'

  _clearCompletedTodos: -> @meteor.call 'clearCompletedTodos'

  _setTodosFilter: (filter) ->

    # only continue if it changed
    if @getState('activeFilter') is filter then return

    switch filter

      when @FILTERS.ALL then @setState 'todos', @todos.find()
      when @FILTERS.ACTIVE then @setState 'todos', @todos.find isCompleted: false
      when @FILTERS.COMPLETED then @setState 'todos', @todos.find isCompleted: true

      else return # only accept valid options

    @setState 'activeFilter', filter
