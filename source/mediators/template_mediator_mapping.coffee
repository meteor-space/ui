
class Space.ui.TemplateMediatorMapping

  constructor: (@template, @injector) ->

  inContext: (@context) -> return this

  toMediator: (mediatorIdentifier) ->

    injector = @injector
    context = @context

    existingCreatedCallback = @template.created
    existingRenderedCallback = @template.rendered
    existingDestroyedCallback = @template.destroyed

    @template.created = ->

      if existingCreatedCallback? then existingCreatedCallback.call this

      if !context? || context? && @data.templateMediatorContext == context

        @mediator = injector.get mediatorIdentifier

        if @mediator.templateCreated? then @mediator.templateCreated this

    @template.rendered = ->

      if existingRenderedCallback? then existingRenderedCallback.call this

      if @mediator? && @mediator.templateRendered? then @mediator.templateRendered this

    @template.destroyed = ->

      if existingDestroyedCallback? then existingDestroyedCallback.call this

      if @mediator? && @mediator.templateDestroyed? then @mediator.templateDestroyed this

      delete @mediator
