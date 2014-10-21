
class Space.ui.TemplateMediatorMap

  @toString: -> 'Space.ui.TemplateMediatorMap'

  Dependencies:
    injector: 'Space.Application.Injector'

  constructor: (@injector) ->

  map: (template) -> new Space.ui.TemplateMediatorMapping template, @injector
