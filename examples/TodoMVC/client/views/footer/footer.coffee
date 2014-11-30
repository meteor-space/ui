
Template.footer.helpers

  pluralize: (count) -> if count is 1 then 'item' else 'items'


Template.footer.events

  'click #clear-completed': (event, template) -> template.mediator.clearCompleted()