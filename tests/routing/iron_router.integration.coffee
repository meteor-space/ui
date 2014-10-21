
describe 'Space.ui', ->

  it 'maps iron-router package', ->

    # ROUTER CLASSES ON CLIENT & SERVER

    class SharedApp extends Space.Application

      RequiredModules: ['Space.ui']

      Dependencies:
        router: 'Space.ui.Router'
        route: 'Space.ui.Route'
        routeController: 'Space.ui.RouteController'

      configure: ->
        expect(@router).not.to.be.undefined
        expect(@router).to.equal Router

        expect(@route).not.to.be.undefined
        expect(@route).to.equal Route

        expect(@routeController).not.to.be.undefined
        expect(@routeController).to.equal RouteController


    new SharedApp()

    if Meteor.isClient

      class ClientApp extends Space.Application

        RequiredModules: ['Space.ui']

        Dependencies:
          ironLocation: 'Space.ui.IronLocation'

        configure: ->

          expect(@ironLocation).not.to.be.undefined
          expect(@ironLocation).to.equal IronLocation

      new ClientApp()