// Don't start routing immediately but define the routes here
FlowRouter.wait();

// Redirect from root path to show all todos
FlowRouter.route('/', {
  triggersEnter: [
    function(context, redirect) {
      redirect('/all');
    }
  ]
});

// Handles various filter modes of todos
FlowRouter.route('/:_filter', {
  action: function(params) {
    TodoMVC.app.publish(new TodoMVC.FilterRouteTriggered({
      filterType: params._filter
    }));
  }
});
