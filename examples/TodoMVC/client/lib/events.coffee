
# Application events with runtime-checked shape
# using Meteor's check and Match API.

Space.messaging.define Space.messaging.Event, {

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
