
class @TodoMVC extends Space.Application

  configure: ->

    # DATA + LOGIC
    @injector.map(TodosCollection).asSingleton()
    @injector.map(TodosController).asSingleton()

  run: ->
    
    @injector.create TodosController