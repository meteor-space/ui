
class Space.ui.ActionDispatcher

  Dependencies:
    dispatcher: 'Space.ui.Dispatcher'

  dispatch: (type, data) -> @dispatcher.dispatch { type: type, data: data }