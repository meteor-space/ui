class @TodosTracker extends Space.messaging.Tracker

  Dependencies:
    store: 'TodosStore'
    meteor: 'Meteor'

  # Reactively subscribe to the todos data based on the active filter
  autorun: -> @meteor.subscribe 'todos', @store.get 'activeFilter'
