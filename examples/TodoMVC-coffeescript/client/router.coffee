# Don't start routing immediately but define the routes here
FlowRouter.wait()

# Redirect from root path to show all todos
FlowRouter.route '/', triggersEnter: [(context, redirect) -> redirect '/all']

# Handles various filter modes of todos
FlowRouter.route '/:_filter', action: (params) ->
  TodoMVC.instance.publish new FilterRouteTriggered filterType: params._filter
