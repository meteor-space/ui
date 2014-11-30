
class @TodosCollection

  @toString: -> 'TodosCollection'

  Dependencies:
    mongo: 'Mongo'

  onDependenciesReady: -> @_collection = new @mongo.Collection 'todos'

  get: -> @_collection