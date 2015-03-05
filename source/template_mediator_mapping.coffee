
class Space.ui.TemplateMediatorMapping

  constructor: (@template, @injector) ->

  toMediator: (mediatorIdentifier) ->

    injector = @injector

    existingCreatedCallback = @template.created
    existingRenderedCallback = @template.rendered
    existingDestroyedCallback = @template.destroyed

    @template.created = ->
      if existingCreatedCallback? then existingCreatedCallback.call this
      @mediator = injector.get mediatorIdentifier
      @mediator.templateCreated this

    @template.rendered = ->
      if existingRenderedCallback? then existingRenderedCallback.call this
      @mediator.templateRendered this

    @template.destroyed = ->
      if existingDestroyedCallback? then existingDestroyedCallback.call this
      @mediator.templateDestroyed this
      delete @mediator
