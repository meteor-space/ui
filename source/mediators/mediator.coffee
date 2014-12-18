
class Space.ui.Mediator extends Space.ui.Messenger

  Dependencies:
    templates: 'Template'

  configure: ->

    template = @templates[@constructor.Template]
    if @templateHelpers?  then template.helpers @templateHelpers()
    if @templateEvents? then template.events @templateEvents()

  # the managed blaze template was created
  templateCreated: (@template) ->

  # the managed blaze template was rendered
  templateRendered: (template) ->

  # the managed blaze template was destroyed
  templateDestroyed: (template) ->

  # sugar to get the Blaze template instance which sent the event
  getEventTarget: (event) -> event.target.$blaze_range.view.templateInstance()