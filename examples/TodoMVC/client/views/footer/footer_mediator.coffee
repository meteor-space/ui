
class @FooterMediator extends Space.ui.Mediator

  @toString: -> 'FooterMediator'

  Dependencies:
    store: 'TodosStore'
    actions: 'Actions'
    _: 'underscore'

  provideState: ->

    state = @store.getState()

    filters = @_.map @store.FILTERS, (key) -> {
      name: key[0].toUpperCase() + key.slice 1
      path: key
    }

    return {
      activeTodosCount: state.activeTodos.count()
      completedTodosCount: state.completedTodos.count()
      availableFilters: filters
    }

  clearCompleted: -> @dispatch @actions.CLEAR_COMPLETED_TODOS