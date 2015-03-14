
class Space.ui.Store extends Space.messaging.Controller

  Dependencies:
    state: 'ReactiveVar'
    underscore: 'underscore'
    tracker: 'Tracker'

  onDependenciesReady: ->
    super()
    @state.set @setInitialState()

  setInitialState: -> {}

  getState: (path) ->
    path = if path? then path.split "." else []
    state = @state.get()
    state = state[key] for key in path
    return state

  setState: (path, value) ->

    # Changes the whole state at once if no path is given
    if arguments.length < 2
      value = path
      @state.set value
      return

    # Sets nested property at path
    existingState = @tracker.nonreactive => @state.get()
    newState = @underscore.clone existingState

    path = path.split "."
    property = newState

    for name, index in path

      if index + 1 < path.length
        # build up missing object path
        property[name] ?= {}
        property = property[name]
      else
        property[name] = value

    @state.set newState

Space.ui.Store::get = Space.ui.Store::getState
Space.ui.Store::set = Space.ui.Store::setState
