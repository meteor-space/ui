
var ENTER_KEY = 13;
var ESCAPE_KEY = 27;

Template.todo.onCreated(function() {
  this.getTitleValue = _.bind(function() {
    return this.$('.edit').val();
  }, this);
});

Template.todo.helpers({

  completedState: function() {
    return this.isCompleted ? 'completed' : '';
  },

  editingState: function() {
    if(this.isEditing) {
      var template = Template.instance();
      if(template.view.isRendered) {
        template.$('.edit').focus().select();
      }
      return 'editing';
    }
    else {
      return '';
    }
  }
});

Template.todo.events({

  'click .toggle': function(event, template) {
    template.$(template.firstNode).trigger('toggled');
  },

  'click .destroy': function(event, template) {
    template.$(template.firstNode).trigger('destroyed');
  },

  'dblclick .todo': function(event, template) {
    template.$(template.firstNode).trigger('doubleClicked');
  },

  'blur .edit': function(event, template) {
    template.$(template.firstNode).trigger('editingCanceled');
  },

  'keyup .edit': function(event, template) {

    switch(event.keyCode) {
      case ESCAPE_KEY:
        template.$(template.firstNode).trigger('editingCanceled');
        break;
      case ENTER_KEY:
        template.$(template.firstNode).trigger('editingCompleted');
        break;
    }
  }
});
