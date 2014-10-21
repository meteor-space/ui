
Munit.run

  name: 'Space.ui - TemplateMediatorMap'
  type: 'client'

  tests: [
    {
      name: 'wiring up a mediator with a specific template'

      func: ->

        defaultGreeting = '[Default greeting]'
        changedGreeting = 'Hello'

        # SIMPLE MEDIATOR -> TEMPLATE MAPPING APP

        class GreetingMediator

          Dependencies:
            greeting: 'ReactiveVar'

          templateCreated: (template) ->

            @greeting.set defaultGreeting
            template.view.template.helpers greeting: => @greeting.get()

        class MediatorApp extends Space.Application

          RequiredModules: [
            'Space.ui'
          ]

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
    }

    {
      name: 'using contexts to wire up different mediators for the same template'

      func: ->

        firstMediatorGreeting = 'first greeting'
        secondMediatorGreeting = 'second greeting'

        # SIMPLE MEDIATOR -> TEMPLATE MAPPING APP

        class FirstGreetingMediator

          Dependencies:
            greeting: 'ReactiveVar'

          templateCreated: (template) ->

            @greeting.set firstMediatorGreeting
            template.view.template.helpers greeting: => @greeting.get()

        class SecondGreetingMediator

          Dependencies:
            greeting: 'ReactiveVar'

          templateCreated: (template) ->

            @greeting.set secondMediatorGreeting
            template.view.template.helpers greeting: => @greeting.get()

        class MediatorApp extends Space.Application

          RequiredModules: [
            'Space.ui'
          ]

          Dependencies:
            templates: 'Template'
            templateMediatorMap: 'Space.ui.TemplateMediatorMap'

          configure: ->
            @injector.map('FirstGreetingMediator').toClass FirstGreetingMediator
            @injector.map('SecondGreetingMediator').toClass SecondGreetingMediator

            @templateMediatorMap.map(@templates.context_greeting).inContext('first').toMediator 'FirstGreetingMediator'
            @templateMediatorMap.map(@templates.context_greeting).inContext('second').toMediator 'SecondGreetingMediator'

        mediatorApp = new MediatorApp()

        # MATERIALIZE TEMPLATE

        firstContainer = document.createElement 'DIV'
        secondContainer = document.createElement 'DIV'

        Blaze.render Template.first_greeting, firstContainer
        expect(firstContainer.innerHTML.trim()).to.equal firstMediatorGreeting

        Blaze.render Template.second_greeting, secondContainer
        expect(secondContainer.innerHTML.trim()).to.equal secondMediatorGreeting

    }
  ]
