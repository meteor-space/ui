
class Space.ui.Messenger

  Dependencies:
    dispatcher: 'Space.ui.Dispatcher'
    underscore: 'underscore'

  actions: null
  dispatcherId: null

  constructor: -> @actions = {}

  onDependenciesReady: ->
    if @configure? then @configure()
    @_registerAsMessageHandler()

  bindActions: ->

    actions = Array.prototype.slice.call arguments

    if actions.length % 2 != 0
      throw new Error "bindActions must take an even number of arguments."

    for type, index in actions by 2
      @actions[type] = actions[index+1]

    # create handle actions method
    @handleActions = (action) =>

      method = @actions[action.type]
      if method? then this[method](action.data)

    @_registerAsMessageHandler()

  dispatch: (type, data) -> @dispatcher.dispatch { type: type, data: data }

  _registerAsMessageHandler: ->

    isNotYetRegistered = !@dispatcherId?
    canHandleActions = @handleActions? and @underscore.isFunction(@handleActions)

    if isNotYetRegistered and canHandleActions
      @dispatcherId = @dispatcher.register @handleActions