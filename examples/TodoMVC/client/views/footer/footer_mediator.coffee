
class TodoMVC.FooterMediator extends Space.ui.Mediator

  @Template: 'footer'

  Dependencies:
    store: 'TodosStore'
    actions: 'Actions'
    _: 'underscore'

  templateHelpers: ->

    # make store data available to the template via the 'state' helper
    state: =>

      store = @store.getState()

      filters = @_.map @store.FILTERS, (key) -> {
        name: key[0].toUpperCase() + key.slice 1
        path: key
      }

      return {
        activeTodosCount: store.activeTodos.count()
        completedTodosCount: store.completedTodos.count()
        availableFilters: filters
      }

    pluralize: (count) -> if count is 1 then 'item' else 'items'

  templateEvents: ->

    'click #clear-completed': => @actions.clearCompletedTodos()