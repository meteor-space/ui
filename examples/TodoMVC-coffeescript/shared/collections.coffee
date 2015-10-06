TodoMVC.Todos = new Mongo.Collection 'todos'

# Contrived example! Here you could specify your real rules
TodoMVC.Todos.allow
  insert: -> true
  update: -> true
  remove: -> true
