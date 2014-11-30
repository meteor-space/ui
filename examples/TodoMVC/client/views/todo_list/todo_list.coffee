
Template.todo_list.helpers

  isToggleChecked: ->
    if @hasAnyTodos and @allTodosCompleted then 'checked' else false

  prepareTodoData: ->
    @isEditing = Template.instance().mediator.isEditingTodo @_id
    return this

Template.todo_list.events

  'toggled .todo': (event, template) ->

    todo = event.target.$blaze_range.view.templateInstance()
    template.mediator.toggleTodo todo.data

  'destroyed .todo': (event, template) ->

    todo = event.target.$blaze_range.view.templateInstance()
    template.mediator.destroyTodo todo.data

  'doubleClicked .todo': (event, template) ->

    todo = event.target.$blaze_range.view.templateInstance()
    template.mediator.startEditingTodo todo.data

  'editingCanceled .todo': (event, template) ->

    template.mediator.stopEditing()

  'editingCompleted .todo': (event, template) ->

    todo = event.target.$blaze_range.view.templateInstance()
    template.mediator.changeTodoTitle todo: todo.data, newTitle: todo.getTitleValue()

  'click #toggle-all': (event, template) -> template.mediator.toggleAll()