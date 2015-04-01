
Meteor.publish 'todos', (filter) ->
  # Publish filtered data based on the filter parameter
  switch filter
    when 'all' then Todos.find()
    when 'active' then Todos.find isCompleted: false
    when 'completed' then Todos.find isCompleted: true
    else @ready()
