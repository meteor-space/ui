
class @FooterComponent extends Space.ui.BlazeComponent

  @register 'footer'

  Dependencies:
    store: 'TodosStore'
    meteor: 'Meteor'

  setDefaultState: -> availableFilters: @_mapAvailableFilters()

  setReactiveState: ->
    activeTodosCount: @store.get('activeTodos').count()
    completedTodosCount: @store.get('completedTodos').count()

  pluralize: (count) -> if count is 1 then 'item' else 'items'

  events: -> [
    'click #clear-completed': (event) -> @meteor.call 'clearCompletedTodos'
  ]

  _mapAvailableFilters: -> _.map @store.FILTERS, (key) ->
    name: key[0].toUpperCase() + key.slice 1
    path: key
