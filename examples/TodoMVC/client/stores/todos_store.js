
Space.ui.Store.extend(TodoMVC, 'TodosStore', {

  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },

  Dependencies: {
    todos: 'TodoMVC.Todos'
  },

  setDefaultState: function() {
    return {
      activeFilter: this.FILTERS.ALL
    };
  },

  setReactiveState: function() {
    return {
      todos: this.todos.find(),
      completedTodos: this.todos.findCompletedTodos(),
      activeTodos: this.todos.findActiveTodos(),
    };
  }
})

.on(TodoMVC.TodoCreated, function(event) {
  this.todos.insert({
    title: event.title,
    isCompleted: false
  });
})

.on(TodoMVC.TodoDeleted, function(event) {
  this.todos.remove(event.todoId);
})

.on(TodoMVC.TodoTitleChanged, function(event) {
  this.todos.update(event.todoId, {
    $set: {
      title: event.newTitle
    }
  });
})

.on(TodoMVC.TodoToggled, function(event) {
  var isCompleted = this.todos.findOne(event.todoId).isCompleted;
  this.todos.update(event.todoId, {
    $set: {
      isCompleted: !isCompleted
    }
  });
})

.on(TodoMVC.FilterChanged, function(event) {
  if (this.get('activeFilter') === event.filter) { return; }
  switch (event.filter) {
    case this.FILTERS.ALL:
      this.set('todos', this.todos.find());
      break;
    case this.FILTERS.ACTIVE:
      this.set('todos', this.todos.find({
        isCompleted: false
      }));
      break;
    case this.FILTERS.COMPLETED:
      this.set('todos', this.todos.find({
        isCompleted: true
      }));
      break;
  }
  this.set('activeFilter', event.filter);
});
