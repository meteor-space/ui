
class @FooterMediator extends Space.ui.Mediator

  @Template: 'footer'

  Dependencies:
    store: 'TodosStore'
    commandBus: 'Space.messaging.CommandBus'

  setInitialState: ->
    activeTodosCount: @store.get('activeTodos').count()
    completedTodosCount: @store.get('completedTodos').count()
    availableFilters: @_mapAvailableFilters()

  onClearCompletedTodos: -> @commandBus.send new ClearCompletedTodos()

  _mapAvailableFilters: -> _.map @store.FILTERS, (key) ->
    name: key[0].toUpperCase() + key.slice 1
    path: key
