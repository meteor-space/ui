
lastId = 1
prefix = 'ID_'

class Space.ui.Dispatcher

  @toString: -> 'Space.ui.Dispatcher'

  constructor: ->
    @_callbacks = {}
    @_isPending = {}
    @_isHandled = {}
    @_isDispatching = false
    @_pendingPayload = null

  register: (callback) ->
    id = prefix + lastId++
    @_callbacks[id] = callback
    return id

  unregister: (id) ->

    if not @_callbacks[id]?
      throw new Error "#{id} does not map to a registered callback."

    delete @_callbacks[id]

  waitFor: (ids) ->

    if not @_isDispatching
      throw new Error "#waitFor must be invoked while dispatching."

    for id in ids

      if @_isPending[id]

        if @_isHandled[id]
          throw new Error "Circular dependency detected while waiting for #{id}."

        continue

      if not @_callbacks[id]?
        throw new Error "#{id} does not map to a registered callback."

      @_invokeCallback id

  dispatch: (payload) ->

    if @_isDispatching
      currentPayload = JSON.stringify @_pendingPayload
      payload = JSON.stringify payload
      throw new Error "Cannot dispatch in the middle of a dispatch.
                       Dispatching: #{currentPayload}
                       Failed: #{payload}"

    @_startDispatching payload

    try
      for id of @_callbacks
        continue if @_isPending[id]
        @_invokeCallback id

    finally
      @_stopDispatching()

  isDispatching: -> @_isDispatching

  _invokeCallback: (id) ->
    @_isPending[id] = true
    @_callbacks[id](@_pendingPayload)
    @_isHandled[id] = true

  _startDispatching: (payload) ->
    for id of @_callbacks
      @_isPending[id] = false
      @_isHandled[id] = false

    @_pendingPayload = payload
    @_isDispatching = true

  _stopDispatching: ->
    @_pendingPayload = null
    @_isDispatching = false