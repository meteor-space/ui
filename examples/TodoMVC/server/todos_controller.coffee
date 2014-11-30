
class @TodosController

  Dependencies:
    meteor: 'Meteor'
    todosCollection: 'TodosCollection'

  onDependenciesReady: ->

    todos = @todosCollection.get()

    @meteor.methods

      'toggle-all-todos': ->

        allTodosCompleted = todos.find(isCompleted: false).count() is 0

        if allTodosCompleted
          todos.update {}, { $set: isCompleted: false }, multi: true
        else
          todos.update {}, { $set: isCompleted: true }, multi: true

      'clear-completed-todos': -> todos.remove isCompleted: true