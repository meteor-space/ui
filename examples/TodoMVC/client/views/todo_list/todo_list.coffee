
mediator = -> Template.instance().mediator
getEventTarget = (event) -> event.target.$blaze_range.view.templateInstance()
getTodo = (event) -> getEventTarget(event).data

Template.todo_list.helpers

  state: -> mediator().getState()

  isToggleChecked: ->
    if @hasAnyTodos and @allTodosCompleted then 'checked' else false

  prepareTodoData: ->
    @isEditing = mediator().editingTodoId.get() is @_id
    return this

Template.todo_list.events

  'toggled .todo': (event) -> mediator().toggleTodo getTodo(event)

  'destroyed .todo': (event) -> mediator().deleteTodo getTodo(event)

  'doubleClicked .todo': (event) -> mediator().editTodo getTodo(event)

  'editingCanceled .todo': -> mediator().stopEditing()

  'editingCompleted .todo': (event) ->
    newTitle = getEventTarget(event).getTitleValue()
    mediator().submitNewTitle getTodo(event), newTitle

  'click #toggle-all': -> mediator().toggleAllTodos()
