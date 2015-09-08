function mediator() {
  return Space.ui.getMediator();
}

function getTodo(event) {
  return Space.ui.getEventTarget(event).data;
}

Template.todo_list.helpers({
  state: function() {
    return mediator().getState();
  },
  isToggleChecked: function() {
    if (this.hasAnyTodos && this.allTodosCompleted) {
      return 'checked';
    } else {
      return false;
    }
  },
  prepareTodoData: function() {
    this.isEditing = mediator().get('editingTodoId') === this._id;
    return this;
  }
});

Template.todo_list.events({
  'toggled .todo': function(event) {
    return mediator().toggleTodo(getTodo(event));
  },
  'destroyed .todo': function(event) {
    return mediator().deleteTodo(getTodo(event));
  },
  'doubleClicked .todo': function(event) {
    return mediator().editTodo(getTodo(event));
  },
  'editingCanceled .todo': function() {
    return mediator().stopEditing();
  },
  'editingCompleted .todo': function(event) {
    var todo = Space.ui.getEventTarget(event);
    var newTitle = todo.getTitleValue();
    return mediator().submitNewTitle(todo.data, newTitle);
  },
  'click #toggle-all': function() {
    return mediator().toggleAllTodos();
  }
});
