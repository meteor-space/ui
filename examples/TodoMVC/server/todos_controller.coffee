
class @TodosController

  Dependencies:
    meteor: 'Meteor'
    todosCollection: 'TodosCollection'

  onDependenciesReady: ->

    todos = @todosCollection.get()

    @meteor.methods

      toggleAllTodos: ->

        allTodosCompleted = todos.find(isCompleted: false).count() is 0

        if allTodosCompleted
          todos.update {}, { $set: isCompleted: false }, multi: true
        else
          todos.update {}, { $set: isCompleted: true }, multi: true

      clearCompletedTodos: -> todos.remove isCompleted: true