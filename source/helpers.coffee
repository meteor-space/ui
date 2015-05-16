
Space.ui.createEvents = (namespace, events) ->

  # Namespace is optional
  if not events?
    events = namespace
    namespace = ''

  parent = Space.resolvePath(namespace)

  for key, fields of events
    parent[key] = Space.messaging.Event.extend ->
      @type namespace + '.' + key
      @fields = fields
      return this

Space.ui.getEventTarget = (event) ->
  event.target.$blaze_range.view.templateInstance()

Space.ui.getMediator = -> Template.instance().mediator
