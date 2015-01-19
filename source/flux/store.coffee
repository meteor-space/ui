
class Space.ui.Store extends Space.ui.Messenger

  Dependencies:
    state: 'ReactiveVar'

  onDependenciesReady: ->
    super()
    if @setInitialState? then @setState(@setInitialState()) else @setState {}

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
    modifiedState = @state.get()
    path = path.split "."
    property = modifiedState

    for name, index in path

      if index + 1 < path.length
        # build up missing object path
        property[name] ?= {}
        property = property[name] 
      else
        property[name] = value

    @state.set modifiedState

Space.ui.Store::get = Space.ui.Store::getState
Space.ui.Store::set = Space.ui.Store::setState