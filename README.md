# space:ui [![Build Status](https://travis-ci.org/CodeAdventure/space-ui.svg?branch=master)](https://travis-ci.org/CodeAdventure/space-ui)

**Meteor UI framework inspired by [React](http://facebook.github.io/react/)
and [Flux](http://facebook.github.io/flux/docs/overview.html).**

## Installation
`meteor add space:ui`

## TodoMVC Example
If you want to know if `space:ui` could be interesting, take a look at
the [TodoMVC example](https://github.com/CodeAdventure/space-ui/tree/master/examples/TodoMVC)

## Core Ideas
Meteor is a great platform for building realtime apps with Javascript, but for bigger applications the lack of conventions and UI architecture can become a real problem. Templating in Meteor is nice but lacks a lot of architectural patterns. When using the standard templates / managers many people start spreading logic in the view layer, where it becomes hard to manage.

The [Flux architecture](http://facebook.github.io/flux/docs/overview.html) developed by Facebook, solves exactly the same problem for applications built apon [React](http://facebook.github.io/react/) components. Its not a real framework, more a set of simple conventions and ideas that play well together. `space:ui` is a thin layer on top of Meteor and Blaze to provide these building blocks for you!

### Centralized Logic
The core idea of Flux is to centralize the front-end logic into **stores**, the only places where application state is managed. They are what you might call *view model* in other frameworks, except that they don't have to map directly to the concept of a *thing* (e.g: Todo). Stores manage the state of parts of your application. This could be anything, from a `VideoPlaybackStore` that manages the current state of a video player, to a [TodosStore](https://github.com/CodeAdventure/space-ui/blob/master/examples/TodoMVC/client/stores/todos_store.coffee) that manages a list of todos.

This doesn't mean that they have to be especially complex, eg. the whole logic of the TodoMVC application easily fits into 45 lines of CoffeeScript if you use this pattern:

```coffeescript
class @TodosStore extends Space.ui.Store

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  setDefaultState: -> activeFilter: @FILTERS.ALL

  setInitialState: ->
    todos: Todos.find()
    completedTodos: Todos.find isCompleted: true
    activeTodos: Todos.find isCompleted: false

  @on TodoCreated, (event) -> Todos.insert title: event.title, isCompleted: false

  @on TodoDeleted, (event) -> Todos.remove event.todoId

  @on TodoTitleChanged, (event) -> Todos.update event.todoId, $set: title: event.newTitle

  @on TodoToggled, (event) ->
    isCompleted = Todos.findOne(event.todoId).isCompleted
    Todos.update event.todoId, $set: isCompleted: !isCompleted

  @on FilterChanged, (event) ->

    # only continue if it changed
    if @get('activeFilter') is event.filter then return

    switch event.filter

      when @FILTERS.ALL then @set 'todos', Todos.find()
      when @FILTERS.ACTIVE then @set 'todos', Todos.find isCompleted: false
      when @FILTERS.COMPLETED then @set 'todos', Todos.find isCompleted: true

      else return # only accept valid options

    @set 'activeFilter', event.filter
```

**If you prefer JavaScript**:
`space:ui` is based on `space:base` which provides a very simple but powerful
[inheritance system](https://github.com/CodeAdventure/meteor-space/wiki/Space.Object) that
can save you from a lot of typing, also when using Javascript :wink:

```javascript
TodosStore = Space.ui.Store.extend({

  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },

  setDefaultState: function() {
    return {
      activeFilter: this.FILTERS.ALL
    };
  }

  setInitialState: function() {
    return {
      todos: Todos.find(),
      completedTodos: Todos.find({ isCompleted: true }),
      activeTodos: Todos.find({ isCompleted: false })
    };
  }
});

TodosStore.on(TodoCreated, function (event) {
  Todos.insert({
    title: event.title,
    isCompleted: false
  });
});

// ... you get the point

```

### Composable Views
The biggest problem with Meteor templates is that they need to get their data from *somewhere*. Unfortunately
there is no good pattern provided by the core team, so everyone has to come up with custom
solutions. `space:ui` introduces **mediators** that manage standard Meteor templates by providing application state to them, interpreting (dumb) template events and publishing business actions. The stores listen to published actions and change their internal state according to its logic. The changes are reactively pushed to mediators that declared their dependency on stores by accessing their data:

```
╔═════════╗       ╔════════╗  state  ╔════════════════╗  state   ╔══════════════════╗
║  Events ║──────>║ Stores ║────────>║    Mediators   ║ <──────> ║ Meteor Templates ║
╚═════════╝       ╚════════╝         ╚════════════════╝  events  ╚══════════════════╝
     ^                                      │ publish
     └──────────────────────────────────────┘

```

This is the **Mediator** for the todo list of the TodoMVC example:

```CoffeeScript
class @TodoListMediator extends Space.ui.Mediator

  @Template: 'todo_list'

  Dependencies:
    store: 'TodosStore'
    meteor: 'Meteor'

  setDefaultState: -> editingTodoId: null

  setInitialState: ->
    todos: @store.get('todos')
    hasAnyTodos: @store.get('todos').count() > 0
    allTodosCompleted: @store.get('activeTodos').count() is 0

  toggleTodo: (todo) -> @publish new TodoToggled todoId: todo._id

  deleteTodo: (todo) -> @publish new TodoDeleted todoId: todo._id

  editTodo: (todo) -> @set 'editingTodoId', todo._id

  submitNewTitle: (todo, newTitle) ->
    @publish new TodoTitleChanged todoId: todo._id, newTitle: newTitle
    @stopEditing()

  toggleAllTodos: -> @meteor.call 'toggleAllTodos'

  stopEditing: -> @set 'editingTodoId', null
```

And it connects to a standard Meteor template view:

```coffeescript
Template.todo_list.helpers

  state: -> mediator().getState()

  isToggleChecked: ->
    if @hasAnyTodos and @allTodosCompleted then 'checked' else false

  prepareTodoData: ->
    @isEditing = mediator().get('editingTodoId') is @_id
    return this

Template.todo_list.events

  'toggled .todo': (event) -> mediator().toggleTodo getTodo(event)

  'destroyed .todo': (event) -> mediator().deleteTodo getTodo(event)

  'doubleClicked .todo': (event) -> mediator().editTodo getTodo(event)

  'editingCanceled .todo': -> mediator().stopEditing()

  'editingCompleted .todo': (event) ->
    todo = Space.ui.getEventTarget(event)
    newTitle = todo.getTitleValue()
    mediator().submitNewTitle todo.data, newTitle

  'click #toggle-all': -> mediator().toggleAllTodos()

mediator = -> Space.ui.getMediator()
getTodo = (event) -> Space.ui.getEventTarget(event).data
```

### Explicit Messaging
Using **pub/sub** messaging between the various layers of your application is an effective way to decouple them. The stores don't know anything about other parts of the system (business logic). Mediators know how to get data from stores and provide an api to their managed templates. Templates don't know anything but to display given data and tell their mediator about user interaction with buttons etc.

Each layer plays an important role and the implementation details can be changed easily.

### Testability & Dependency Injection
`space:ui` makes testing UI logic easy since dependeny injection is built right into the heart of the framework.
With the [Space architecture](https://github.com/CodeAdventure/meteor-space) as foundation the following conventions become important:

1. Dependencies in your code are explicit
2. You have full control over configuration and initialization
3. Testing your stuff is easy

```CoffeeScript
class @IndexController

  Dependencies:
    tracker: 'Tracker'
    router: 'Router'
    eventBus: 'Space.messaging.EventBus'

  onDependenciesReady: ->

    self = this
    # Redirect to show all todos by default
    @router.route '/', -> @redirect '/all'

    # Handles filtering of todos
    @router.route '/:_filter',

      name: 'index'

      onAfterAction: ->
        # Dispatch action non-reactivly to prevent multiple calls
        # this is a drawback of using iron:router TODO: switch to flow-router?
        self.tracker.nonreactive => self._setFilter @params._filter

      subscriptions: ->
        # Subscribe to the filetered data based on the route parameter
        Meteor.subscribe 'todos', @params._filter

  _setFilter: (filter) => @eventBus.publish new FilterChanged filter: filter
```

You might realize that this is a standard CoffeeScript class. You can use any
other mechanism for creating your "classes" or "instances" when using `space:ui`.
The only "magic" that happens here, is that you declare your dependencies
as a simple property `Dependencies` on the function prototype. Nothing special
would happen if you directly created an instance of this class, because there is
no real magic. These are normal properties that function as annotations which are
used to wire up the stuff you need at runtime. The cool thing is: the instance doesn't need to know where the concrete dependencies come from. `space:base`
provides a rock solid implementation of a [simple dependency injector](https://github.com/CodeAdventure/meteor-space/wiki/Space.Injector)

Here you see where the "magic" happens and all the parts of your application are wired up:

```CoffeeScript
class @TodoMVC extends Space.ui.Application

  RequiredModules: ['Space.ui']
  Stores: ['TodosStore']
  Mediators: ['InputMediator', 'TodoListMediator', 'FooterMediator']
  Controllers: ['IndexController']

  configure: ->
    super()
    # Use iron:router for this example app
    @injector.map('Router').to Router
```

## Run the tests
`meteor test-packages ./`

## Run the example TodoMVC
`cd examples/TodoMVC && meteor`

## Release History
You can find the complete release history in the [changelog](https://github.com/CodeAdventure/space-ui/blob/master/CHANGELOG.md)

## License
Copyright (c) 2015 [Code Adventure](http://www.codeadventure.com/)
Licensed under the MIT license.
