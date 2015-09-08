
class @RouteController extends Space.messaging.Controller

  # Tell the rest of the application that the expected filter mode changed
  @on FilterRouteTriggered, (event) ->
    @publish new FilterChanged filter: event.filterType
