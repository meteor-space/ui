
class TodoMVC.RouteController extends Space.messaging.Controller

  events: -> [
    # Tell the rest of the application that the expected filter mode changed
    'TodoMVC.FilterRouteTriggered': (event) ->
      @publish new TodoMVC.FilterChanged filter: event.filterType
  ]
