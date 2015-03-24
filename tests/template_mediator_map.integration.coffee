
describe 'Space.ui (Integration)', ->

  it 'wires up a mediator with a specific template', ->

    defaultGreeting = '[Default greeting]'
    changedGreeting = 'Hello'

    # SIMPLE MEDIATOR -> TEMPLATE MAPPING APP

    class GreetingMediator extends Space.ui.Mediator

      Dependencies: greeting: 'ReactiveVar'

      templateCreated: (template) ->
        @greeting.set defaultGreeting
        template.view.template.helpers greeting: => @greeting.get()

    class MediatorApp extends Space.Application

      RequiredModules: ['Space.ui']

      Dependencies:
        templates: 'Template'
        templateMediatorMap: 'Space.ui.TemplateMediatorMap'

      configure: ->
        @injector.map('GreetingMediator').toSingleton GreetingMediator
        @templateMediatorMap.map(@templates.greeting).toMediator 'GreetingMediator'

    mediatorApp = new MediatorApp()

    # MATERIALIZE TEMPLATE

    container = document.createElement 'DIV'
    Blaze.render Template.greeting, container

    expect(container.innerHTML).to.equal defaultGreeting

    # CHANGE THE REACTIVE PROPERTIES
    mediator = mediatorApp.injector.get 'GreetingMediator'
    mediator.greeting.set changedGreeting

    Tracker.flush() # flush the changes into the template

    expect(container.innerHTML).to.equal changedGreeting
