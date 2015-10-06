
Space.ui.Store.extend(TodoMVC, 'TodosStore', {

  Dependencies: {
    todos: 'TodoMVC.Todos'
  },

  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },

  reactiveVars: function() {
    return [{
      activeFilter: this.FILTERS.ALL
    }];
  },

  filteredTodos: function() {
    switch (this.activeFilter()) {
      case this.FILTERS.ALL: return this.todos.find();
      case this.FILTERS.ACTIVE: return this.todos.find({ isCompleted: false});
      case this.FILTERS.COMPLETED: return this.todos.find({ isCompleted: true });
    }
  },

  completedTodos: function() {
    return this.todos.findCompletedTodos();
  },

  activeTodos: function() {
    return this.todos.findActiveTodos();
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
  this.activeFilter(event.filter);
});
