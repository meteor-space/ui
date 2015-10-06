
class TodoMVC.LayoutController extends Space.messaging.Controller

  Dependencies:
    layout: 'FlowLayout'

  @on TodoMVC.FilterRouteTriggered, (event) -> @layout.render "index"
