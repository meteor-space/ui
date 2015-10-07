
class TodoMVC.LayoutController extends Space.messaging.Controller

  Dependencies:
    layout: 'FlowLayout'

  events: -> [
    'TodoMVC.FilterRouteTriggered': (event) -> @layout.render "index"
  ]
