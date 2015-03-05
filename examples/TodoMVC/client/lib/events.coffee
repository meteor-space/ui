
# Application events with runtime-checked structure

class @TodoCreated extends Space.messaging.Event
  @type 'TodoCreated', -> title: String

class @TodoDeleted extends Space.messaging.Event
  @type 'TodoDeleted', -> todoId: String

class @TodoTitleChanged extends Space.messaging.Event
  @type 'TodoTitleChanged', -> todoId: String, newTitle: String

class @TodoToggled extends Space.messaging.Event
  @type 'TodoToggled', -> todoId: String

class @AllTodosToggled extends Space.messaging.Event
  @type 'AllTodosToggled'

class @CompletedTodosCleared extends Space.messaging.Event
  @type 'CompletedTodosCleared'

class @FilterChanged extends Space.messaging.Event
  @type 'FilterChanged', -> filter: String
