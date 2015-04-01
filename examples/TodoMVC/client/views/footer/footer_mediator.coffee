
class @FooterMediator extends Space.ui.Mediator

  Dependencies:
    store: 'TodosStore'
    commandBus: 'Space.messaging.CommandBus'
    _: 'underscore'

  @Template: 'footer'

  getState: ->

    filters = @_.map @store.FILTERS, (key) ->
      name: key[0].toUpperCase() + key.slice 1
      path: key

    return {
      activeTodosCount: @store.get('activeTodos').count()
      completedTodosCount: @store.get('completedTodos').count()
      availableFilters: filters
    }

  onClearCompletedTodos: -> @commandBus.send new ClearCompletedTodos()
