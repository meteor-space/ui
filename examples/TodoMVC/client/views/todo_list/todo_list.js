
Space.ui.BlazeComponent.extend(TodoMVC, 'TodoList', {

  Dependencies: {
    store: 'TodoMVC.TodosStore',
    meteor: 'Meteor',
  },

  setDefaultState: function() {
    return {
      editingTodoId: null
    };
  },

  allTodos: function() {
    return this.store.get('todos');
  },

  hasAnyTodos: function() {
    return this.store.get('todos').count() > 0;
  },

  allTodosCompleted: function() {
    return this.store.get('activeTodos').count() === 0;
  },

  isToggleChecked: function() {
    if (this.hasAnyTodos() && this.allTodosCompleted()) {
      return 'checked';
    } else {
      return false;
    }
  },

  prepareTodoData: function() {
    todo = this.currentData();
    todo.isEditing = this.get('editingTodoId') === todo._id;
    return todo;
  },

  events: function() {
    return [{
      'toggled .todo': this.toggleTodo,
      'destroyed .todo': this.deleteTodo,
      'doubleClicked .todo': this.editTodo,
      'editingCanceled .todo': this.stopEditing,
      'editingCompleted .todo': this.submitNewTitle,
      'click #toggle-all': this.toggleAllTodos
    }];
  },

  toggleTodo: function() {
    this.publish(new TodoMVC.TodoToggled({
      todoId: this.currentData()._id
    }));
  },

  deleteTodo: function() {
    this.publish(new TodoMVC.TodoDeleted({
      todoId: this.currentData()._id
    }));
  },

  editTodo: function(event) {
    this.set('editingTodoId', this.currentData()._id);
  },

  submitNewTitle: function(event) {
    var todo = Space.ui.getEventTarget(event);
    var newTitle = todo.getTitleValue();
    this.publish(new TodoMVC.TodoTitleChanged({
      todoId: todo.data._id,
      newTitle: newTitle
    }));
    this.stopEditing();
  },

  toggleAllTodos: function() {
    this.meteor.call('toggleAllTodos');
  },

  stopEditing: function() {
    this.set('editingTodoId', null);
  },
})
// Register blaze-component for template
.register('todo_list');