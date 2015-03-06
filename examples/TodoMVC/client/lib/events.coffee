
# Application events with runtime-checked structure

Space.ui.createEvents

  TodoCreated: title: String

  TodoDeleted: todoId: String

  TodoTitleChanged: todoId: String, newTitle: String

  TodoToggled: todoId: String

  AllTodosToggled: {}

  CompletedTodosCleared: {}

  FilterChanged: filter: String
