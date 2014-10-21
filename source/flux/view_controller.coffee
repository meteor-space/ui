
class Space.ui.ViewController extends Space.ui.ActionDispatcher

  templateCreated: (@template) ->
    @template.view.template.helpers state: => @provideState()