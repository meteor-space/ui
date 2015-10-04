
Space.ui.Mediator.extend(TodoMVC, 'TodoListMediator', {

  Dependencies: {
    store: 'TodoMVC.TodosStore',
    meteor: 'Meteor',
  },

  setDefaultState: function() {
    return {
      editingTodoId: null
    };
  },

  setReactiveState: function() {
    return {
      todos: this.store.get('todos'),
      hasAnyTodos: this.store.get('todos').count() > 0,
      allTodosCompleted: this.store.get('activeTodos').count() === 0
    };
  },

  toggleTodo: function(todo) {
    this.publish(new TodoMVC.TodoToggled({
      todoId: todo._id
    }));
  },

  deleteTodo: function(todo) {
    this.publish(new TodoMVC.TodoDeleted({ todoId: todo._id }));
  },

  editTodo: function(todo) {
    this.set('editingTodoId', todo._id);
  },

  submitNewTitle: function(todo, newTitle) {
    this.publish(new TodoMVC.TodoTitleChanged({
      todoId: todo._id,
      newTitle: newTitle
    }));
    this.stopEditing();
  },

  toggleAllTodos: function() {
    this.meteor.call('toggleAllTodos');
  },

  stopEditing: function() {
    this.set('editingTodoId', null);
  }
});

TodoMVC.TodoListMediator.Template = 'todo_list';
