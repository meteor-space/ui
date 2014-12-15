
class Space.ui.Mediator extends Space.ui.Messenger

  templateHelpers: -> {}
  templateEvents: -> {}

  # the managed blaze template was created
  templateCreated: (@template) ->

    helpers = @templateHelpers()

    unless helpers.state?
      # default helper to provide data to the managed template
      helpers.state = => @provideState()

    @template.view.template.helpers helpers
    @template.view.template.events @templateEvents()

  # the managed blaze template was rendered
  templateRendered: (template) ->

  # the managed blaze template was destroyed
  templateDestroyed: (template) ->

  getEventTarget: (event) -> event.target.$blaze_range.view.templateInstance()