
class @TodoListMediator extends Space.ui.Mediator

  @toString: -> 'TodoListMediator'

  Dependencies:
    store: 'TodosStore'
    actions: 'Actions'
    editingTodoId: 'ReactiveVar'

  onDependenciesReady: -> @editingTodoId.set null

  provideState: -> {
    todos: @store.getState().todos
    hasAnyTodos: @store.getState().todos.count() > 0
    allTodosCompleted: @store.getState().activeTodos.count() is 0
    editingTodoId: @editingTodoId.get()
  }

  toggleTodo: (todo) -> @dispatch @actions.TOGGLE_TODO, todo

  destroyTodo: (todo) -> @dispatch @actions.DESTROY_TODO, todo

  startEditingTodo: (todo) -> @editingTodoId.set todo._id

  isEditingTodo: (todoId) -> @editingTodoId.get() is todoId

  stopEditing: -> @editingTodoId.set null

  changeTodoTitle: (data) ->
    @dispatch @actions.CHANGE_TODO_TITLE, data
    @stopEditing()

  toggleAll: -> @dispatch @actions.TOGGLE_ALL_TODOS
