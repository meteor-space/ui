
class Space.ui.Mediator extends Space.ui.ActionDispatcher

  templateCreated: (@template) ->
    @template.view.template.helpers state: => @provideState()