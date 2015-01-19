
class TodoMVC.TodoListMediator extends Space.ui.Mediator

  @Template: 'todo_list'

  Dependencies:
    store: 'TodosStore'
    actions: 'Actions'
    editingTodoId: 'ReactiveVar'

  templateHelpers: ->

    mediator = this

    state: => {
      todos: @store.get('todos')
      hasAnyTodos: @store.get('todos').count() > 0
      allTodosCompleted: @store.get('activeTodos').count() is 0
      editingTodoId: @editingTodoId.get()
    }

    isToggleChecked: ->
      # 'this' is the template instance here
      if @hasAnyTodos and @allTodosCompleted then 'checked' else false

    prepareTodoData: ->
      @isEditing = mediator.editingTodoId.get() is @_id
      return this


  templateEvents: ->

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
