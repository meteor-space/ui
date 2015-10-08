
Space.ui.Store.extend(TodoMVC, 'TodosStore', {

  // The store needs a reference to the todos collection
  Dependencies: {
    todos: 'TodoMVC.Todos'
  },

  // TodoMVC example specific properties
  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },
  
  _session: 'TodoMVC.TodosStoreSession',

  // ====== Public reactive data accessors ======= //

  // These methods can be used by other parts of the system to
  // fetch reactive data and auto-update when store data changes.

  reactiveVars: function() {
    return [{
      activeFilter: this.FILTERS.ALL,
    }];
  },

  sessionVars: function() {
    return [{
      editingTodoId: null
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
  },

  // ====== Event handling setup ====== //

  // Map private methods to events coming from the outside
  // this is the only way state can change within the store.

  events: function() {
    return [{
      'TodoMVC.TodoCreated': this._insertNewTodo,
      'TodoMVC.TodoDeleted': this._removeTodo,
      'TodoMVC.TodoEditingStarted': this._setEditingTodoId,
      'TodoMVC.TodoEditingEnded': this._unsetEditingTodoId,
      'TodoMVC.TodoTitleChanged': this._updateTodoTitle,
      'TodoMVC.TodoToggled': this._toggleTodo,
      'TodoMVC.FilterChanged': this._changeActiveFilter
    }];
  },

  _insertNewTodo: function(event) {
    this.todos.insert({
      title: event.title,
      isCompleted: false
    });
  },

  _removeTodo: function(event) {
    this.todos.remove(event.todoId);
  },

  _setEditingTodoId: function(event) {
    this._setSessionVar('editingTodoId', event.todoId);
  },

  _unsetEditingTodoId: function() {
    this._setSessionVar('editingTodoId', null);
  },

  _updateTodoTitle: function(event) {
    this.todos.update(event.todoId, {
      $set: {
        title: event.newTitle
      }
    });
  },

  _toggleTodo: function(event) {
    var isCompleted = this.todos.findOne(event.todoId).isCompleted;
    this.todos.update(event.todoId, {
      $set: {
        isCompleted: !isCompleted
      }
    });
  },

  _changeActiveFilter: function(event) {
    this._setReactiveVar('activeFilter', event.filter);
  }

});
