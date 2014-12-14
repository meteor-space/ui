
class Space.ui.Store extends Space.ui.Messenger

  Dependencies:
    state: 'ReactiveVar'

  onDependenciesReady: ->
    super()
    if @setInitialState? then @setState @setInitialState()

  getState: -> @state.get()

  setState: (path, value) ->

    # Case: change the whole state at once
    if arguments.length < 2
      value = path
      @state.set value
      return

    modifiedState = @state.get()
    path = path.split "."
    property = modifiedState

    for name, index in path

      if index + 1 < path.length
        property = property[name]
      else
        property[name] = value

    @state.set modifiedState
