TodosTracker = Space.messaging.Tracker.extend('TodosTracker', {

  Dependencies: {
    store: 'TodosStore',
    meteor: 'Meteor',
  },

  // Reactively subscribe to the todos data based on the active filter
  autorun: function() {
    this.meteor.subscribe('todos', this.store.get('activeFilter'));
  }

});
