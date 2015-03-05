
Template.footer.helpers

  # Make store data available to the template via the 'state' helper
  state: -> Template.instance().mediator.getState()

  pluralize: (count) -> if count is 1 then 'item' else 'items'

Template.footer.events

  'click #clear-completed': (event, template) ->
    template.mediator.onClearCompletedTodos()
