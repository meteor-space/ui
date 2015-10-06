
class TodoMVC.TodoList extends Space.ui.BlazeComponent

  # Register blaze-component for template
  @register 'todo_list'

  Dependencies: {
    store: 'TodoMVC.TodosStore'
    meteor: 'Meteor'
  }

  setDefaultState: -> editingTodoId: null

  allTodos: -> @store.get('todos');

  hasAnyTodos: -> @store.get('todos').count() > 0

  allTodosCompleted: -> @store.get('activeTodos').count() is 0

  isToggleChecked: ->
    if @hasAnyTodos() && @allTodosCompleted() then 'checked' else false

  prepareTodoData: ->
    todo = @currentData()
    todo.isEditing = @get('editingTodoId') is todo._id
    return todo

  events: -> [{
    'toggled .todo': @toggleTodo
    'destroyed .todo': @deleteTodo
    'doubleClicked .todo': @editTodo
    'editingCanceled .todo': @stopEditing
    'editingCompleted .todo': @submitNewTitle
    'click #toggle-all': @toggleAllTodos
  }]

  toggleTodo: -> @publish new TodoMVC.TodoToggled {
    todoId: @currentData()._id
  }

  deleteTodo: -> @publish new TodoMVC.TodoDeleted {
    todoId: @currentData()._id
  }

  editTodo: -> @set 'editingTodoId', @currentData()._id

  submitNewTitle: (event) ->
    todo = Space.ui.getEventTarget(event)
    newTitle = todo.getTitleValue()
    @publish new TodoMVC.TodoTitleChanged {
      todoId: todo.data._id,
      newTitle: newTitle
    }
    @stopEditing()

  toggleAllTodos: -> @meteor.call 'toggleAllTodos'

  stopEditing: -> @set 'editingTodoId', null
