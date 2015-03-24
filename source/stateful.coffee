
Space.ui.Stateful =

  Dependencies:
    state: 'ReactiveVar'
    underscore: 'underscore'
    tracker: 'Tracker'

  get: (path) ->
    path = if path? then path.split "." else []
    state = @state.get()
    state = state[key] for key in path
    return state

  set: (path, value) ->

    # Changes the whole state at once if no path is given
    if arguments.length < 2
      value = path
      @state.set value
      return

    # Sets nested property at path
    existingState = @tracker.nonreactive => @state.get()

    if existingState?
      newState = @underscore.clone existingState
    else
      newState = {}

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

Space.ui.Stateful.getState = Space.ui.Stateful.get
Space.ui.Stateful.setState = Space.ui.Stateful.set
