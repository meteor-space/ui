# space:ui [![Build Status](https://travis-ci.org/CodeAdventure/space-ui.svg?branch=master)](https://travis-ci.org/CodeAdventure/space-ui)

**Meteor UI framework inspired by [React](http://facebook.github.io/react/) and [Flux](http://facebook.github.io/flux/docs/overview.html).**

## Installation
`meteor add space:ui`

## TodoMVC Example
If you want to know if `space:ui` could be interesting, take a look at
the [TodoMVC example](https://github.com/CodeAdventure/space-ui/tree/master/examples/TodoMVC)

## Core Ideas
Meteor is a great platform for building realtime apps with Javascript, but for bigger applications the lack of conventions and UI architecture can become a real problem. Templating in Meteor is nice but lacks a lot of architectural patterns. When using the standard templates / managers a lot of people start spreading logic in the view layer, where becomes hard to test.

The [Flux architecture](http://facebook.github.io/flux/docs/overview.html) developed
by Facebook, solved exactly the same problem for applications built apon [React](http://facebook.github.io/react/) components. Its not a real framework, more a set of simple conventions and ideas that play very well together. `space:ui` is a very thin layer on top of Meteor and Blaze to provide these building blocks for you too!

### Centralized Logic
The core idea of Flux is to centralize the application logic into **Stores**, the only places where data is actually created, mutated and deleted. They are what you might call *model* in other frameworks, except that they don't have to map directly to the concept of a *thing* (e.g: Todo). Stores represent a business domain within your application. This could be anything, from a `VideoPlaybackStore` that manages the current state of a video player, to a [TodosStore](https://github.com/CodeAdventure/space-ui/blob/master/examples/TodoMVC/client/stores/todos_store.coffee) that manages a list of todos.

This doesn't mean that they have to be especially complex, eg. the whole business logic of the TodoMVC application easily fits into 60 lines of CoffeeScript if you use this pattern:

```CoffeeScript
class TodoMVC.TodosStore extends Space.ui.Store

  Dependencies:
    todos: 'Todos'
    actions: 'Actions'
    meteor: 'Meteor'

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  setInitialState: -> {
    todos: @todos.find()
    completedTodos: @todos.find isCompleted: true
    activeTodos: @todos.find isCompleted: false
    activeFilter: @FILTERS.ALL
  }

  configure: ->

    @listenTo(
      @actions.toggleTodo, @_toggleTodo
      @actions.createTodo, @_createTodo
      @actions.destroyTodo, @_destroyTodo
      @actions.changeTodoTitle, @_changeTodoTitle
      @actions.toggleAllTodos, @_toggleAllTodos
      @actions.clearCompletedTodos, @_clearCompletedTodos
      @actions.setTodosFilter, @_setTodosFilter
    )

  _createTodo: (title) -> @todos.insert title: title, isCompleted: false

  _destroyTodo: (todo) -> @todos.remove todo._id

  _changeTodoTitle: (data) -> @todos.update data.todo._id, $set: title: data.newTitle

  _toggleTodo: (todo) -> @todos.update todo._id, $set: isCompleted: !todo.isCompleted

  _toggleAllTodos: -> @meteor.call 'toggleAllTodos'

  _clearCompletedTodos: -> @meteor.call 'clearCompletedTodos'

  _setTodosFilter: (filter) ->

    # only continue if it changed
    if @getState('activeFilter') is filter then return

    switch filter

      when @FILTERS.ALL then @setState 'todos', @todos.find()
      when @FILTERS.ACTIVE then @setState 'todos', @todos.find isCompleted: false
      when @FILTERS.COMPLETED then @setState 'todos', @todos.find isCompleted: true

      else return # only accept valid options

    @setState 'activeFilter', filter

```

**If you prefer JavaScript**:
I would highly recommend using some simple library to make classical inheritance easier.
[class](https://github.com/CodeAdventure/meteor-class) is a small but mighty package to help you write code like this:

```JavaScript
Class('TodoMVC.TodosStore', {

  Extends: Space.ui.Store,

  Dependencies: {
    todos: 'Todos',
    actions: 'Actions',
    meteor: 'Meteor',
  },

  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },

  setInitialState: function() {
    return {
      todos: this.todos.find(),
      completedTodos: this.todos.find({ isCompleted: true }),
      activeTodos: this.todos.find({ isCompleted: false }),
      activeFilter: this.FILTERS.ALL
    };
  }

  // ... you get the point ;-)
});
```

### Composable Views
The biggest problem with Meteor templates is that they need to get their data from *somewhere*. Unfortunately
there is no good pattern provided by the core team, so everyone has to come up with custom
solutions. `space:ui` introduces **mediators** that manage standard Meteor templates by providing application state to them, interpreting (dumb) template events and publishing business actions. The stores listen to published actions and change their internal state according to its business logic. The changes are reactively (normal meteor `reactive-var`) pushed to mediators that declared their dependency on stores by accessing their data:

```
╔═════════╗       ╔════════╗  state  ╔════════════════╗  state   ╔══════════════════╗
║ Actions ║──────>║ Stores ║────────>║    Mediators   ║ <──────> ║ Meteor Templates ║
╚═════════╝       ╚════════╝         ╚════════════════╝  events  ╚══════════════════╝
     ^                                      │ publish
     └──────────────────────────────────────┘

```

This is the **Mediator** for the todo list of the TodoMVC example:

```CoffeeScript

class TodoMVC.TodoListMediator extends Space.ui.Mediator

  @Template: 'todo_list'

  Dependencies:
    store: 'TodosStore'
    actions: 'Actions'
    editingTodoId: 'ReactiveVar'

  templateHelpers: ->

    mediator = this

    # Provide state to the managed template
    state: => {
      todos: @store.getState().todos # declare reactive dependency on the store
      hasAnyTodos: @store.getState().todos.count() > 0
      allTodosCompleted: @store.getState().activeTodos.count() is 0
      editingTodoId: @editingTodoId.get()
    }

    # Standard template helper (could also be defined like normal)
    isToggleChecked: ->
      # 'this' is the template instance here
      if @hasAnyTodos and @allTodosCompleted then 'checked' else false

    prepareTodoData: ->
      @isEditing = mediator.editingTodoId.get() is @_id
      return this


  templateEvents: ->

    'toggled .todo': (event) => @actions.toggleTodo @getEventTarget(event).data

    'destroyed .todo': (event) => @actions.destroyTodo @getEventTarget(event).data

    'doubleClicked .todo': (event) => @editingTodoId.set @getEventTarget(event).data._id

    'editingCanceled .todo': => @_stopEditing()

    'editingCompleted .todo': (event) =>

      todo = @getEventTarget event
      data = todo: todo.data, newTitle: todo.getTitleValue()

      @actions.changeTodoTitle data
      @_stopEditing()

    'click #toggle-all': => @actions.toggleAllTodos()

  _stopEditing: -> @editingTodoId.set null

```

### Explicit Messaging
Using **pub/sub** messaging between the various layers of your application is an effective way to decouple them.
The stores don't know anything about other parts of the system (business logic). Mediators know
how to get data from stores and to interpret events from their managed templates. Templates don't know
anything but to display given data and publish events about user interaction with buttons etc.

Each layer plays an important role and the implementation details can be changed easily.

### Testability & Dependency Injection
`space:ui` makes testing UI logic easy since dependeny injection is built right into the heart of the framework.
With the [Space architecture](https://github.com/CodeAdventure/meteor-space) as foundation the following conventions become important:

1. No global variables in custom code (except libraries)
2. Clear dependency declarations (`Dependencies` property on prototype)
3. Don't force me into a coding-style (plain Coffeescript classes / Javascript prototypes)

```CoffeeScript
class TodoMVC.IndexController

  Dependencies:
    actions: 'Actions'
    tracker: 'Tracker'
    router: 'Router'

  onDependenciesReady: ->

    self = this

    # redirect to show all todos by default
    @router.route '/', -> @redirect '/all'

    # handles filtering of todos
    @router.route '/:_filter', {

      name: 'index'

      onBeforeAction: ->
        filter = @params._filter
        # dispatch action non-reactivly to prevent endless-loops
        self.tracker.nonreactive -> self._setFilter filter
        @next()
    }

  _setFilter: (filter) => @actions.setTodosFilter filter
```

You might realize that this is a standard CoffeeScript class. You can use any
other mechanism for creating your "classes" or "instances" when using `space:ui`. 
The only "magic" that happens here, is that you declare your dependencies 
as a simple property `Dependencies` on the function prototype. Nothing special 
would happen if you directly created an instance of this class, because there is 
no real magic. These are normal properties that function as annotations which are 
used to wire up the stuff you need at runtime.
The cool thing is: the instance doesn't need to know where the concrete dependencies
come from. They could be injected by [Dependance](https://github.com/CodeAdventure/meteor-dependance)
(The dependency injection framework included with `space:ui`) or added by your test setup.

Here you see where the "magic" happens and all the parts of your application are wired up:

```CoffeeScript
class TodoMVC.Application extends Space.Application

  RequiredModules: ['Space.ui']

  Dependencies:
    mongo: 'Mongo'
    templateMediatorMap: 'Space.ui.TemplateMediatorMap'
    actionFactory: 'Space.ui.ActionFactory'

  configure: ->

    # ACTIONS
    @injector.map('Actions').toStaticValue @actionFactory.create [
      'toggleTodo'
      'createTodo'
      'destroyTodo'
      'changeTodoTitle'
      'toggleAllTodos'
      'clearCompletedTodos'
      'setTodosFilter'
    ]

    # DATA + LOGIC
    @injector.map('Todos').toStaticValue new @mongo.Collection 'todos'
    @injector.map('TodosStore').toSingleton TodoMVC.TodosStore

    # ROUTING WITH IRON-ROUTER
    @injector.map('Router').toStaticValue Router
    @injector.map('IndexController').toSingleton TodoMVC.IndexController

    # TEMPLATE MEDIATORS
    @templateMediatorMap.autoMap 'TodoListMediator', TodoMVC.TodoListMediator
    @templateMediatorMap.autoMap 'InputMediator', TodoMVC.InputMediator
    @templateMediatorMap.autoMap 'FooterMediator', TodoMVC.FooterMediator

  run: ->
    @injector.create 'TodosStore'
    @injector.create 'IndexController' # start routing
```

## Run the tests
`meteor test-packages ./`

## Run the example TodoMVC
`cd examples/TodoMVC && meteor`

## Release History
* 3.4.0 - Removes iron-router suppport and its dependency on it.
* 3.3.0 - Improves the Mediator api for creating template helpers and event handlers
* 3.2.0 - Adds simplified api for creating and dispatching actions (see TodoMVC example)
* 3.1.0 - Introduces auto-mapping of mediators and templates via annotations
* 3.0.0 - Cleans up the mediator API and removed old relicts that are not used anymore
* 2.0.0 - Update to the latest 1.0.3 verison of iron:router and fast-render packages
* 1.0.0 - Publish first version to Meteor package system

## License
Copyright (c) 2015 Code Adventure
Licensed under the MIT license.
