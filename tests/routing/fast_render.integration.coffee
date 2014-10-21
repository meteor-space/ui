
describe 'Space.ui', ->

  it 'maps fast-render package', ->

    class App extends Space.Application

      RequiredModules: ['Space.ui']

      Dependencies:
        fastRender: 'Space.ui.FastRender'

      configure: ->
        expect(@fastRender).to.equal FastRender
        expect(@fastRender).not.to.be.undefined

    new App()