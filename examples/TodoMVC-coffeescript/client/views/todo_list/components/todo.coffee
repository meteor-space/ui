
ENTER_KEY = 13
ESCAPE_KEY = 27

Template.todo.created = ->

  @getTitleValue = => @$('.edit').val()

Template.todo.helpers

  completedState: -> if @isCompleted then 'completed' else ''

  editingState: ->
    if @isEditing
      template = Template.instance()
      template.$('.edit').focus().select() if template.view.isRendered
      return 'editing'
    else
      return ''

Template.todo.events

  'click .toggle': (event, template) ->
    template.$(template.firstNode).trigger 'toggled'

  'click .destroy': (event, template) ->
    template.$(template.firstNode).trigger 'destroyed'

  'dblclick .todo': (event, template) ->
    template.$(template.firstNode).trigger 'doubleClicked'

  'blur .edit': (event, template) ->
    template.$(template.firstNode).trigger 'editingCanceled'

  'keyup .edit': (event, template) ->

    switch event.keyCode

      when ESCAPE_KEY
        template.$(template.firstNode).trigger 'editingCanceled'

      when ENTER_KEY
        template.$(template.firstNode).trigger 'editingCompleted'
