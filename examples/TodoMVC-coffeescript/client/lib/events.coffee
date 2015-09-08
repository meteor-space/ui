
# Application events with runtime-checked shape
# using Meteor's check and Match API.
Space.ui.createEvents {

  FilterRouteTriggered: {
    filterType: String
  }

  TodoCreated: {
    title: String
  }

  TodoDeleted: {
    todoId: String
  }

  TodoTitleChanged: {
    todoId: String
    newTitle: String
  }

  TodoToggled: {
    todoId: String
  }

  FilterChanged: {
    filter: String
  }

}
