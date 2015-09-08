
Template.todo_list.helpers

  state: -> mediator().getState()

  isToggleChecked: ->
    if @hasAnyTodos and @allTodosCompleted then 'checked' else false

  prepareTodoData: ->
    @isEditing = mediator().get('editingTodoId') is @_id
    return this

Template.todo_list.events

  'toggled .todo': (event) -> mediator().toggleTodo getTodo(event)

  'destroyed .todo': (event) -> mediator().deleteTodo getTodo(event)

  'doubleClicked .todo': (event) -> mediator().editTodo getTodo(event)

  'editingCanceled .todo': -> mediator().stopEditing()

  'editingCompleted .todo': (event) ->
    todo = Space.ui.getEventTarget(event)
    newTitle = todo.getTitleValue()
    mediator().submitNewTitle todo.data, newTitle

  'click #toggle-all': -> mediator().toggleAllTodos()

mediator = -> Space.ui.getMediator()
getTodo = (event) -> Space.ui.getEventTarget(event).data
