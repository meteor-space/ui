
class Space.ui.ActionHandler

  Dependencies:
    dispatcher: 'Space.ui.Dispatcher'

  actions: null
  dispatcherId: null

  constructor: -> @actions = {}

  onDependenciesReady: -> @dispatcherId = @dispatcher.register @handleActions

  bindActions: ->

    actions = Array.prototype.slice.call arguments

    if actions.length % 2 != 0
      throw new Error "bindActions must take an even number of arguments."

    for type, index in actions by 2
      @actions[type] = actions[index+1]

  handleActions: (action) =>

    method = @actions[action.type]
    if method? then this[method](action.data)