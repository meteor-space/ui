
class TodoMVC.RouteController extends Space.messaging.Controller

  # Tell the rest of the application that the expected filter mode changed
  @on TodoMVC.FilterRouteTriggered, (event) ->
    @publish new TodoMVC.FilterChanged filter: event.filterType
