
class @TodoListMediator extends Space.ui.Mediator

  Dependencies:
    store: 'TodosStore'
    commandBus: 'Space.messaging.CommandBus'

  @Template: 'todo_list'

  setInitialState: ->
    todos: @store.get('todos')
    hasAnyTodos: @store.get('todos').count() > 0
    allTodosCompleted: @store.get('activeTodos').count() is 0
    editingTodoId: null

  toggleTodo: (todo) -> @publish new TodoToggled todoId: todo._id

  deleteTodo: (todo) -> @publish new TodoDeleted todoId: todo._id

  editTodo: (todo) -> @set 'editingTodoId', todo._id

  submitNewTitle: (todo, newTitle) ->
    @publish new TodoTitleChanged todoId: todo._id, newTitle: newTitle
    @stopEditing()

  toggleAllTodos: -> @commandBus.send new ToggleAllTodos()

  stopEditing: -> @set 'editingTodoId', null
