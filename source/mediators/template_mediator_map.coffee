
class Space.ui.TemplateMediatorMap

  @toString: -> 'Space.ui.TemplateMediatorMap'

  Dependencies:
    injector: 'Space.Application.Injector'
    templates: 'Template'

  constructor: (@injector) ->

  map: (template) -> new Space.ui.TemplateMediatorMapping template, @injector

  autoMap: (identifier, mediatorClass) ->

    @injector.map(identifier).toSingleton mediatorClass

    template = @templates[mediatorClass.Template]
    mapping = new Space.ui.TemplateMediatorMapping template, @injector

    if mediatorClass.context? then mapping.inContext mediatorClass.context

    mapping.toMediator identifier