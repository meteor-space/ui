
TodosStore = Space.ui.Store.extend('TodosStore', {

  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },

  Dependencies: {
    todos: 'Todos'
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

.on(TodoCreated, function(event) {
  this.todos.insert({
    title: event.title,
    isCompleted: false
  });
})

.on(TodoDeleted, function(event) {
  this.todos.remove(event.todoId);
})

.on(TodoTitleChanged, function(event) {
  this.todos.update(event.todoId, {
    $set: {
      title: event.newTitle
    }
  });
})

.on(TodoToggled, function(event) {
  var isCompleted = this.todos.findOne(event.todoId).isCompleted;
  this.todos.update(event.todoId, {
    $set: {
      isCompleted: !isCompleted
    }
  });
})

.on(FilterChanged, function(event) {
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
