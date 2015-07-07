class @TodosPublication extends Space.messaging.Publication

  Dependencies:
    todosCollection: 'Todos'

  @publish 'todos', (filter) ->
    # Publish filtered data based on the filter parameter
    switch filter
      when 'all' then @todosCollection.find()
      when 'active' then @todosCollection.find isCompleted: false
      when 'completed' then @todosCollection.find isCompleted: true
      else @ready()
