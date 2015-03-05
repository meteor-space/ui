
class @TodoListMediator extends Space.ui.Mediator

  Dependencies:
    store: 'TodosStore'
    editingTodoId: 'ReactiveVar'

  getState: ->
    todos: @store.get('todos')
    hasAnyTodos: @store.get('todos').count() > 0
    allTodosCompleted: @store.get('activeTodos').count() is 0
    editingTodoId: @editingTodoId.get()

  toggleTodo: (todo) -> @publish new TodoToggled todoId: todo._id

  deleteTodo: (todo) -> @publish new TodoDeleted todoId: todo._id

  editTodo: (todo) -> @editingTodoId.set todo._id

  submitNewTitle: (todo, newTitle) ->
    @publish new TodoTitleChanged todoId: todo._id, newTitle: newTitle
    @stopEditing()

  toggleAllTodos: -> @publish new AllTodosToggled()

  stopEditing: -> @editingTodoId.set null
