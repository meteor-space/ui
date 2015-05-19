
class Space.ui.TemplateMediatorMapping

  constructor: (@template, @injector) ->

  toMediator: (mediatorIdentifier) ->

    injector = @injector

    if @template.onCreated?
      # Compatibility for Meteor > 1.0
      @template.onCreated ->
        @mediator = injector.get mediatorIdentifier
        @mediator.templateCreated this

      @template.onRendered -> @mediator.templateRendered this

      @template.onDestroyed ->
        @mediator.templateDestroyed this
        delete @mediator
    else
      # Compatibility for Meteor < 1.1
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
