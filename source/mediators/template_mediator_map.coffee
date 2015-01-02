
class Space.ui.TemplateMediatorMap

  @toString: -> 'Space.ui.TemplateMediatorMap'

  Dependencies:
    injector: 'Space.Application.Injector'
    templates: 'Template'

  ERRORS:
    noTemplateDefined: 'Please declare a @Template for auto-mapping.'

  constructor: (@injector) ->

  map: (template) -> new Space.ui.TemplateMediatorMapping template, @injector

  autoMap: (identifier, mediatorClass) ->

    if not mediatorClass? then mediatorClass = identifier

    @injector.map(identifier).toSingleton mediatorClass

    if not mediatorClass.Template? then throw new Error @ERRORS.noTemplateDefined

    template = @templates[mediatorClass.Template]
    mapping = new Space.ui.TemplateMediatorMapping template, @injector

    if mediatorClass.context? then mapping.inContext mediatorClass.context

    mapping.toMediator identifier
