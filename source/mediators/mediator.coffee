
class Space.ui.Mediator extends Space.ui.Messenger

  templateCreated: (@template) ->
    @template.view.template.helpers state: => @provideState()