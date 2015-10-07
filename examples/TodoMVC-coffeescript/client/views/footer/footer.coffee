
class TodoMVC.Footer extends Space.ui.BlazeComponent

  @register 'footer'

  Dependencies:
    store: 'TodoMVC.TodosStore'
    meteor: 'Meteor'

  filters: -> _.map @store.FILTERS, (key) ->
    name: key[0].toUpperCase() + key.slice 1
    path: key

  activeTodosCount: -> @store.activeTodos().count()

  completedTodosCount: -> @store.completedTodos().count()

  pluralize: (count) -> if count is 1 then 'item' else 'items'

  events: -> [
    'click #clear-completed': (event) -> @meteor.call 'clearCompletedTodos'
  ]
