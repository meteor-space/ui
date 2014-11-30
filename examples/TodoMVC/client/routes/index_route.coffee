
class @IndexRoute extends Space.ui.Route

  @toString: -> 'IndexRoute'

  Dependencies:
    actions: 'Actions'
    tracker: 'Tracker'

  path: '/:_filter'
  name: 'index'
  template: 'index'

  onDependenciesReady: ->

    self = this

    @onBeforeAction = ->

      filter = @params._filter

      # dispatch action non-reactivly to prevent endless-loops
      self.tracker.nonreactive -> self.dispatch self.actions.SET_FILTER, filter

      @next()