
class TodoMVC.TodoListMediator extends Space.ui.Mediator

  @Template: 'todo_list'

  Dependencies:
    store: 'TodosStore'
    actions: 'Actions'
    editingTodoId: 'ReactiveVar'

  templateHelpers: -> # TEMPLATE HELPERS

    mediator = this

    state: => {
      todos: @store.getState().todos
      hasAnyTodos: @store.getState().todos.count() > 0
      allTodosCompleted: @store.getState().activeTodos.count() is 0
      editingTodoId: @editingTodoId.get()
    }

    isToggleChecked: ->
      # 'this' is the template instance here
      if @hasAnyTodos and @allTodosCompleted then 'checked' else false

    prepareTodoData: ->
      @isEditing = mediator.editingTodoId.get() is @_id
      return this


  templateEvents: -> # TEMPLATE EVENTS

    'toggled .todo': (event) => @actions.toggleTodo @getEventTarget(event).data

    'destroyed .todo': (event) => @actions.destroyTodo @getEventTarget(event).data

    'doubleClicked .todo': (event) => @editingTodoId.set @getEventTarget(event).data._id

    'editingCanceled .todo': => @_stopEditing()

    'editingCompleted .todo': (event) =>

      todo = @getEventTarget event
      data = todo: todo.data, newTitle: todo.getTitleValue()

      @actions.changeTodoTitle data
      @_stopEditing()

    'click #toggle-all': => @actions.toggleAllTodos()

  _stopEditing: -> @editingTodoId.set null
