
class @FooterMediator extends Space.ui.Mediator

  @Template: 'footer'

  Dependencies:
    store: 'TodosStore'
    commandBus: 'Space.messaging.CommandBus'

  setDefaultState: -> availableFilters: @_mapAvailableFilters()

  setInitialState: ->
    activeTodosCount: @store.get('activeTodos').count()
    completedTodosCount: @store.get('completedTodos').count()

  onClearCompletedTodos: -> @commandBus.send new ClearCompletedTodos()

  _mapAvailableFilters: -> _.map @store.FILTERS, (key) ->
    name: key[0].toUpperCase() + key.slice 1
    path: key
