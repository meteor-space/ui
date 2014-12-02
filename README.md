# space:ui [![Build Status](https://travis-ci.org/CodeAdventure/space-ui.svg?branch=master)](https://travis-ci.org/CodeAdventure/space-ui)

**Meteor UI framework based on concepts from [Facebook Flux](http://facebook.github.io/flux/docs/overview.html).**

## Installation
`meteor add space:ui`

## TodoMVC Example
If you just want to know if `space:ui` could be interesting for you take a look at
the [TodoMVC application](https://github.com/CodeAdventure/space-ui/tree/master/examples/TodoMVC)
that was built as a reference and idomatic example.

## Core Ideas
Meteor is a great platform for building realtime apps with Javascript, but it doesn't really have
a front-end framework that could compete with [Angular](https://angularjs.org/) or [Ember](http://emberjs.com/).

The templating package of Meteor is somewhat comparable with [React.js](http://facebook.github.io/react/)
but lacks a lot of philosophy and good architectural patterns. In big applications things can
get ugly pretty quickly when using standard templates / managers. They are hard to test and compose, force you
to do data fetching and processing in the view layer (where it doesn't belong) and sport a horrible syntax
(`Template.my_view.events()`).

At the same time one can write beautiful and testable Meteor applications when carefully sticking
to the core ideas of the [Flux architecture](http://facebook.github.io/flux/docs/overview.html) developed
by Facebook. The cool thing is you don't have to add huge amounts of code to provide you with
all buildings blocks to implement Flux, so its a very lightweight alternative to using Angular or React as your UI layer in Meteor.

### Centralized Logic
The core idea of Flux is to centralize the places where the application logic lives.
**Stores** are the only places where data is actually created, mutated and
deleted. They are what you would call *model* in other frameworks, except that they don't have to map
directly to the concept of a *thing* (e.g: Todo). Stores represent a business domain within your application.
The [TodoMVC example](https://github.com/CodeAdventure/space-ui/tree/master/examples/TodoMVC) only has a
single [TodosStore](https://github.com/CodeAdventure/space-ui/blob/master/examples/TodoMVC/client/stores/todos_store.coffee) because the whole business logic of a TodoMVC application easily fits into 60 lines
of CoffeeScript if you use this pattern:

```CoffeeScript
class @TodosStore extends Space.ui.Store

  Dependencies:
    todosCollection: 'TodosCollection'
    actions: 'Actions'
    meteor: 'Meteor'

  FILTERS:
    ALL: 'all'
    ACTIVE: 'active'
    COMPLETED: 'completed'

  onDependenciesReady: ->
    @todos = @todosCollection.get()
    super()

  setInitialState: -> {
    todos: @todos.find()
    completedTodos: @todos.find isCompleted: true
    activeTodos: @todos.find isCompleted: false
    activeFilter: @FILTERS.ALL
  }

  configure: ->

    @bindActions(
      @actions.TOGGLE_TODO, '_toggleTodo'
      @actions.CREATE_TODO, '_createTodo'
      @actions.DESTROY_TODO, '_destroyTodo'
      @actions.CHANGE_TODO_TITLE, '_changeTodoTitle'
      @actions.TOGGLE_ALL_TODOS, '_toggleAll'
      @actions.CLEAR_COMPLETED_TODOS, '_clearCompleted'
      @actions.SET_FILTER, '_setFilter'
    )

  _toggleTodo: (todo) -> @todos.update todo._id, $set: isCompleted: !todo.isCompleted

  _createTodo: (title) -> @todos.insert title: title, isCompleted: false

  _destroyTodo: (todo) -> @todos.remove todo._id

  _changeTodoTitle: (data) -> @todos.update data.todo._id, $set: title: data.newTitle

  _toggleAll: -> @meteor.call 'toggle-all-todos'

  _clearCompleted: -> @meteor.call 'clear-completed-todos'

  _setFilter: (filter) ->

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
Class('TodosStore', {

  Extends: Space.ui.Store,

  Dependencies: {
    todosCollection: 'TodosCollection',
    actions: 'Actions',
    meteor: 'Meteor',
  },

  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },

  onDependenciesReady: function() {
    this.todos = this.todosCollection.get();
    this.Class.Super.protoype.onDependenciesReady.call(this);
  },

  setInitialState: function() {
    return {
      todos: this.todos.find(),
      completedTodos: this.todos.find isCompleted: true,
      activeTodos: this.todos.find isCompleted: false,
      activeFilter: this.FILTERS.ALL
    };
  }

  // ... you get the point ;-)
});
```

### Composable Views
The biggest problem with Meteor templates is that they need to get their data from *somewhere*. Unfortunately
there is no good pattern provided by the core team, so everyone painfully has to come up with custom
solutions. I think this might be the worst part of the whole Meteor platform. Imagine how amazing it would be
if we had a mature view layer like React.js to compose our Meteor UIs and carefully inject the (immutable) data
into the managing views. The data would always flow in one direction: **Stores** -> **Mediators** ->
**Templates** -> (events) -> **Mediators** -> (actions) -> **Dispatcher** -> **Stores** (mutate data and continue cycle).

This is the **ViewController** for the todo list of the TodoMVC example:
```CoffeeScript
class @TodoListMediator extends Space.ui.Mediator

  Dependencies:
    store: 'TodosStore'
    actions: 'Actions'
    editingTodoId: 'ReactiveVar'

  onDependenciesReady: -> @editingTodoId.set null

  provideState: -> {
    todos: @store.getState().todos
    hasAnyTodos: @store.getState().todos.count() > 0
    allTodosCompleted: @store.getState().activeTodos.count() is 0
    editingTodoId: @editingTodoId.get()
  }

  toggleTodo: (todo) -> @dispatch @actions.TOGGLE_TODO, todo

  destroyTodo: (todo) -> @dispatch @actions.DESTROY_TODO, todo

  startEditingTodo: (todo) -> @editingTodoId.set todo._id

  isEditingTodo: (todoId) -> @editingTodoId.get() is todoId

  stopEditing: -> @editingTodoId.set null

  changeTodoTitle: (data) ->
    @dispatch @actions.CHANGE_TODO_TITLE, data
    @stopEditing()

  toggleAll: -> @dispatch @actions.TOGGLE_ALL_TODOS
```

### Explicit Messaging
As you can see, the most important addition to the standard Meteor templates are the **Mediators** which
provide data to their managed sub-templates and react to events that bubble up. They turn the events into
business actions and dispatch them to the rest of the application. The stores receive the actions and act.
This makes the features of your app extremely explicit, you can see everything that the TodoMVC application
is capable of doing in [7 lines of actions definition](https://github.com/CodeAdventure/space-ui/blob/master/examples/TodoMVC/client/actions.coffee).

Using messaging between the various layers of your application is an effective way to decouple them.
The stores don't know anything about other parts of the system (core domain). Mediators know
how to get data from stores and to interpret events from their child templates. Templates don't know
anything but to display given data and publish events about user interaction with buttons etc.

Each layer plays an important role and the implementation details can be changed easily. This is how
you can refactor huge parts of your application without getting crazy.

### Testability & Dependency Injection
There is one thing Angular.js got really right: building dependeny injection into the heart of the framework.
The [Space architecture](https://github.com/CodeAdventure/meteor-space) goes a similar route and `space:ui`
follows the conventions:

1. No global variables
2. Clear dependency declarations
3. Don't force me into your coding-style (Biggest mistake of Angular.js)

```CoffeeScript
class @IndexController extends Space.ui.RouteController

  Dependencies:
    actions: 'Actions'
    tracker: 'Tracker'
    dispatcher: 'Space.ui.Dispatcher'

  configure: ->

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

  _setFilter: (filter) => @dispatch @actions.SET_FILTER, filter

```

You might realize that this is a standard CoffeeScript class which simply extends
a core class of the package. You will never see anything else while working with `space:ui`,
because I think the biggest mistake a lot of frameworks make, is to force you into a specific way
to write your code. The only "magic" that happens here, is that you declare your dependencies
as a simple property `Dependencies` on the class prototype. Nothing would happen if you directly
created an instance of this class, because there is no real magic. These special properties are
like annotations that can be used by other parts of the application to wire up the stuff you need
at runtime. The cool thing is: the instance doesn't need to know where the concrete dependencies
came from. They could be injected by [Dependance](https://github.com/CodeAdventure/meteor-dependance)
(the dependency injection framework included with `space:ui`) or added by your test setup.

Here you see where the "magic" happens and all the parts of your application are wired up:

```CoffeeScript
class @TodoMVC extends Space.Application

  RequiredModules: ['Space.ui']

  Dependencies:
    templates: 'Template'
    templateMediatorMap: 'Space.ui.TemplateMediatorMap'

  configure: ->

    # DATA + LOGIC
    @injector.map(TodosCollection).asSingleton()
    @injector.map(TodosStore).asSingleton()
    @injector.map('Actions').toStaticValue ACTIONS

    # ROUTING
    @injector.map(IndexController).asSingleton()

    # VIEWS
    @injector.map(TodoListMediator).asSingleton()
    @injector.map(InputMediator).asSingleton()
    @injector.map(FooterMediator).asSingleton()

    @templateMediatorMap.map(@templates.todo_list).toMediator TodoListMediator
    @templateMediatorMap.map(@templates.input).toMediator InputMediator
    @templateMediatorMap.map(@templates.footer).toMediator FooterMediator

  run: ->
    @injector.create TodosStore
    @injector.create IndexController # start routing
```

## Run the tests
`meteor test-packages ./`

## Release History
* 2.0.0 - Update to the latest 1.0.3 verison of iron:router and fast-render packages
* 1.0.0 - Publish first version to Meteor package system

## License
Copyright (c) 2014 Code Adventure
Licensed under the MIT license.
