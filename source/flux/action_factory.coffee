
class Space.ui.ActionFactory

  @toString: -> 'Space.ui.ActionFactory'

  Dependencies:
    dispatcher: 'Space.ui.Dispatcher'

  create: (actions) ->

    context = {}
    @_createAction(action, context) for action in actions

    return context

  _createAction: (actionType, context) ->

    context[actionType] = (data) => @dispatcher.dispatch type: actionType, data: data
    context[actionType].type = actionType