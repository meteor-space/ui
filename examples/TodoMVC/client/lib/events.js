
// Application events with runtime-checked shape
// using Meteor's check and Match API.
Space.ui.defineEvents('TodoMVC', {

  FilterRouteTriggered: {
    filterType: String
  },

  TodoCreated: {
    title: String
  },

  TodoDeleted: {
    todoId: String
  },

  TodoEditingStarted: {
    todoId: String
  },

  TodoEditingEnded: {
    todoId: String
  },

  TodoTitleChanged: {
    todoId: String,
    newTitle: String
  },

  TodoToggled: {
    todoId: String
  },

  FilterChanged: {
    filter: String
  }

});
