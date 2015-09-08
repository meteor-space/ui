
class @LayoutController extends Space.messaging.Controller

  Dependencies:
    layout: 'FlowLayout'

  @on FilterRouteTriggered, (event) -> @layout.render "index"
