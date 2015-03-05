
class Space.ui.TemplateMediatorMap

  Dependencies:
    injector: 'Injector'

  constructor: (@injector) ->

  map: (template) -> new Space.ui.TemplateMediatorMapping template, @injector
