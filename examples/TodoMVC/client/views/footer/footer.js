
Space.ui.BlazeComponent.extend(TodoMVC, 'Footer', {

  Dependencies: {
    store: 'TodoMVC.TodosStore',
    meteor: 'Meteor'
  },

  setDefaultState: function() {
    return {
      availableFilters: this._mapAvailableFilters()
    };
  },

  setReactiveState: function() {
    return {
      activeTodosCount: this.store.get('activeTodos').count(),
      completedTodosCount: this.store.get('completedTodos').count()
    };
  },

  pluralize: function(count) {
    if(count === 1) {
      return 'item';
    }
    else {
      return 'items';
    }
  },

  events: function() {
    return [{
      'click #clear-completed': function(event) {
        this.meteor.call('clearCompletedTodos');
      }
    }];
  },

  _mapAvailableFilters: function() {
    return _.map(this.store.FILTERS, function(key) {
      return {
        name: key[0].toUpperCase() + key.slice(1),
        path: key
      };
    });
  }
})

.register('footer'); // BlazeComponent API to register with template
