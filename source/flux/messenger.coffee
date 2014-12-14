
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

    @_registerAsMessageHandler()

  listenTo: ->

    actions = Array.prototype.slice.call arguments

    if actions.length % 2 != 0
      throw new Error "listenTo takes an even number of arguments."

    for action, index in actions by 2
      @actions[action.type] = @underscore.bind actions[index+1], this

  handleActions: (action) =>

    method = @actions[action.type]

    if @underscore.isString(method) then this[method](action.data)
    else method(action.data)

  dispatch: (type, data) -> @dispatcher.dispatch { type: type, data: data }

  _registerAsMessageHandler: ->

    if !@dispatcherId? then @dispatcherId = @dispatcher.register @handleActions