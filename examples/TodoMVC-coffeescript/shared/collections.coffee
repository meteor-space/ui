@Todos = new Mongo.Collection 'todos'

# Contrived example! Here you could specify your real rules
@Todos.allow
  insert: -> true
  update: -> true
  remove: -> true
