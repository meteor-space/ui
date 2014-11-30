
describe 'Space.ui', ->

  it 'maps iron-router package', ->

    # ROUTER CLASSES ON CLIENT & SERVER

    class SharedApp extends Space.Application

      RequiredModules: ['Space.ui']

      Dependencies:
        router: 'Space.ui.Router'
        routeController: 'Space.ui.RouteController'

      configure: ->
        expect(@router).not.to.be.undefined
        expect(@router).to.equal Router

        expect(@routeController).not.to.be.undefined
        expect(@routeController).to.equal RouteController


    new SharedApp()