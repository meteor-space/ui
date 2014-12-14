
class TodoMVC.TodoListMediator extends Space.ui.Mediator

  @Template: 'todo_list'

  Dependencies:
    store: 'TodosStore'
    actions: 'Actions'
    editingTodoId: 'ReactiveVar'

  provideState: -> {
    todos: @store.getState().todos
    hasAnyTodos: @store.getState().todos.count() > 0
    allTodosCompleted: @store.getState().activeTodos.count() is 0
    editingTodoId: @editingTodoId.get()
  }

  toggleTodo: (todo) -> @actions.toggleTodo todo

  destroyTodo: (todo) -> @actions.destroyTodo todo

  startEditingTodo: (todo) -> @editingTodoId.set todo._id

  isEditingTodo: (todoId) -> @editingTodoId.get() is todoId

  stopEditing: -> @editingTodoId.set null

  changeTodoTitle: (data) ->
    @actions.changeTodoTitle(data)
    @stopEditing()

  toggleAll: -> @actions.toggleAllTodos()
