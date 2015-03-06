
class Space.ui.TemplateMediatorMap

  Dependencies:
    injector: 'Injector'
    templates: 'Template'

  ERRORS:
    noTemplateDefined: 'Please declare a @Template for auto-mapping.'

  constructor: (@injector) ->

  map: (template) -> new Space.ui.TemplateMediatorMapping template, @injector

  autoMap: (identifier) ->

    @injector.map(identifier).asSingleton()

    if typeof(identifier) is 'string'
      mediator = Space.resolvePath(identifier)
    else
      mediator = identifier

    if not mediator.Template? then throw new Error @ERRORS.noTemplateDefined

    template = @templates[mediator.Template]
    mapping = new Space.ui.TemplateMediatorMapping template, @injector

    mapping.toMediator identifier
