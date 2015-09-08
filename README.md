# space:ui [![Build Status](https://travis-ci.org/meteor-space/ui.svg?branch=master)](https://travis-ci.org/meteor-space/ui)

**Meteor UI framework inspired by [React](http://facebook.github.io/react/)
and [Flux](http://facebook.github.io/flux/docs/overview.html).**

## Installation
`meteor add space:ui`

## TodoMVC Example
If you want to know if `space:ui` could be interesting, take a look at
the [TodoMVC example](https://github.com/meteor-space/ui/tree/master/examples/)

## Core Ideas
Meteor is a great platform for building realtime apps with Javascript, but for bigger applications the lack of conventions and UI architecture can become a real problem. Templating in Meteor is nice but lacks a lot of architectural patterns. When using the standard templates / managers many people start spreading logic in the view layer, where it becomes hard to manage.

The [Flux architecture](http://facebook.github.io/flux/docs/overview.html) developed by Facebook, solves exactly the same problem for applications built apon [React](http://facebook.github.io/react/) components. Its not a real framework, more a set of simple conventions and ideas that play well together. `space:ui` is a thin layer on top of Meteor and Blaze to provide these building blocks for you!

### Centralized Logic
The core idea of Flux is to centralize the front-end logic into **stores**, the only places where application state is managed. They are what you might call *view model* in other frameworks, except that they don't have to map directly to the concept of a *thing* (e.g: Todo). Stores manage the state of parts of your application. This could be anything, from a `VideoPlaybackStore` that manages the current state of a video player, to a [TodosStore](https://github.com/meteor-space/ui/blob/master/examples/TodoMVC/client/stores/todos_store.coffee) that manages a list of todos.

This doesn't mean that they have to be especially complex, eg. the whole logic of the TodoMVC application easily fits into 45 lines of CoffeeScript if you use this pattern:

```coffeescript
class @TodosStore extends Space.ui.Store

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  Dependencies:
    todos: 'Todos'

  setDefaultState: -> {
    activeFilter: @FILTERS.ALL
  }

  setReactiveState: -> {
    todos: @todos.find()
    completedTodos: @todos.find isCompleted: true
    activeTodos: @todos.find isCompleted: false
  }

  @on TodoCreated, (event) -> @todos.insert title: event.title, isCompleted: false

  @on TodoDeleted, (event) -> @todos.remove event.todoId

  @on TodoTitleChanged, (event) -> @todos.update event.todoId, $set: title: event.newTitle

  @on TodoToggled, (event) ->
    isCompleted = @todos.findOne(event.todoId).isCompleted
    @todos.update event.todoId, $set: isCompleted: !isCompleted

  @on FilterChanged, (event) ->

    # only continue if it actually changed
    if @get('activeFilter') is event.filter then return

    switch event.filter

      when @FILTERS.ALL then @set 'todos', @todos.find()
      when @FILTERS.ACTIVE then @set 'todos', @todos.find isCompleted: false
      when @FILTERS.COMPLETED then @set 'todos', @todos.find isCompleted: true

      else return # only accept valid options

    @set 'activeFilter', event.filter
```

**If you prefer JavaScript**:
`space:ui` is based on `space:base` which provides a very simple but powerful
[inheritance system](https://github.com/CodeAdventure/meteor-space/wiki/Space.Object) that
can save you from a lot of typing, also when using Javascript :wink:

```javascript
Space.ui.Store.extend(window, 'TodosStore', {

  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },

  Dependencies: {
    todos: 'Todos'
  },

  setDefaultState: function() {
    return {
      activeFilter: this.FILTERS.ALL
    };
  }

  setInitialState: function() {
    return {
      todos: this.todos.find(),
      completedTodos: this.todos.find({ isCompleted: true }),
      activeTodos: this.todos.find({ isCompleted: false })
    };
  }
})

.on(TodoCreated, function (event) {
  this.todos.insert({
    title: event.title,
    isCompleted: false
  });
});

// ... you get the point

```

### Composable Views
The biggest problem with Meteor templates is that they need to get their data
from *somewhere*. Unfortunately there is no good pattern provided by the core
team, so everyone has to come up with custom solutions. `space:ui` introduces
the concepts of **mediators** that manage standard Meteor templates by providing
application state to them, interpreting (dumb) template events and publishing business
actions. The stores listen to published actions and change their internal
state according to its logic. The changes are reactively pushed to mediators
that declared their dependency on stores by accessing their data:

```
╔═════════╗       ╔════════╗  state  ╔════════════════╗  state   ╔══════════════════╗
║  Events ║──────>║ Stores ║────────>║    Mediators   ║ <──────> ║ Meteor Templates ║
╚═════════╝       ╚════════╝         ╚════════════════╝  events  ╚══════════════════╝
     ^                                      │ publish
     └──────────────────────────────────────┘

```

This is the **Mediator** for the todo list of the TodoMVC example:

```coffeescript
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

#### Integration with blaze-components

You are not limited to the standard Meteor templates, `space:ui` also fully
integrates with the fantastic [blaze-components](https://github.com/peerlibrary/meteor-blaze-components)
package via the `Space.ui.BlazeComponent` class.

Here is the footer component of the TodoMVC example:

```coffeescript
class @FooterComponent extends Space.ui.BlazeComponent

  @register 'footer' # blaze-components specific

  Dependencies:
    store: 'TodosStore'
    meteor: 'Meteor'

  setDefaultState: -> availableFilters: @_mapAvailableFilters()

  setReactiveState: ->
    activeTodosCount: @store.get('activeTodos').count()
    completedTodosCount: @store.get('completedTodos').count()

  pluralize: (count) -> if count is 1 then 'item' else 'items'

  # Also a blaze-components API
  events: -> [
    'click #clear-completed': (event) -> @meteor.call 'clearCompletedTodos'
  ]

  _mapAvailableFilters: -> _.map @store.FILTERS, (key) ->
    name: key[0].toUpperCase() + key.slice 1
    path: key
```

As you can see, the integration is seamless – you can use the full blaze-components
API while having dependency injection and state management from `space:ui`

### Explicit Messaging
Using **pub/sub** messaging between the various layers of your application is an effective way to decouple them. The stores don't know anything about other parts of the system (business logic). Mediators know how to get data from stores and provide an api to their managed templates. Templates don't know anything but to display given data and tell their mediator about user interaction with buttons etc.

Each layer plays an important role and the implementation details can be changed easily.

### Testability & Dependency Injection
`space:ui` makes testing UI logic easy since dependeny injection is built right into the heart of the framework.
With the [Space architecture](https://github.com/CodeAdventure/meteor-space) as foundation the following conventions become important:

1. Dependencies in your code are explicit
2. You have full control over configuration and initialization
3. Testing your stuff is easy

```coffeescript
class @LayoutController extends Space.messaging.Controller

  Dependencies:
    layout: 'FlowLayout'

  @on FilterRouteTriggered, (event) -> @layout.render "index"
```

You might realize that this is a standard Coffeescript class. You can use any
other mechanism for creating your "classes" or "instances" when using `space:ui`.
The only "magic" that happens here, is that you declare your dependencies
as a simple property `Dependencies` on the function prototype. Nothing special
would happen if you directly created an instance of this class, because there is
no real magic. These are normal properties that function as annotations which are
used to wire up the stuff you need at runtime. The cool thing is: the instance doesn't need to know where the concrete dependencies come from. `space:base`
provides a rock solid implementation of a [simple dependency injector](https://github.com/CodeAdventure/meteor-space/wiki/Space.Injector)

Here you see where the "magic" happens and all the parts of your application are wired up:

```coffeescript
class @TodoMVC extends Space.ui.Application

  RequiredModules: ['Space.ui']
  Stores: ['TodosStore']
  Mediators: ['TodoListMediator']
  Components: ['InputComponent', 'FooterComponent']
  Controllers: ['RouteController', 'LayoutController']
  Singletons: ['TodosTracker']
```

## Run the tests
`meteor test-packages ./`

## Run the example TodoMVC
`cd examples/TodoMVC && meteor`

## Release History
You can find the complete release history in the [changelog](https://github.com/meteor-space/ui/blob/master/CHANGELOG.md)

## License
Licensed under the MIT license.
