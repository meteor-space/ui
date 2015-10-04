Space.messaging.Tracker.extend(TodoMVC, 'TodosTracker', {

  Dependencies: {
    store: 'TodoMVC.TodosStore',
    meteor: 'Meteor',
  },

  // Reactively subscribe to the todos data based on the active filter
  autorun: function() {
    this.meteor.subscribe('todos', this.store.get('activeFilter'));
  }

});
