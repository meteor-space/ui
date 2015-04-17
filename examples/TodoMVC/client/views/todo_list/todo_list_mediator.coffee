
class @TodoListMediator extends Space.ui.Mediator

  @Template: 'todo_list'

  Dependencies:
    store: 'TodosStore'
    commandBus: 'Space.messaging.CommandBus'

  setDefaultState: -> editingTodoId: null

  setInitialState: ->
    todos: @store.get('todos')
    hasAnyTodos: @store.get('todos').count() > 0
    allTodosCompleted: @store.get('activeTodos').count() is 0

  toggleTodo: (todo) -> @publish new TodoToggled todoId: todo._id

  deleteTodo: (todo) -> @publish new TodoDeleted todoId: todo._id

  editTodo: (todo) -> @set 'editingTodoId', todo._id

  submitNewTitle: (todo, newTitle) ->
    @publish new TodoTitleChanged todoId: todo._id, newTitle: newTitle
    @stopEditing()

  toggleAllTodos: -> @commandBus.send new ToggleAllTodos()

  stopEditing: -> @set 'editingTodoId', null
