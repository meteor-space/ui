# space:flux [![Build Status](https://travis-ci.org/meteor-space/flux.svg?branch=master)](https://travis-ci.org/meteor-space/flux)

**Centrally manage View Component state to gain control over your Meteor UI**

### Table of Contents:
* [Installation](#installation)
* [Examples](#examples)
* [Concepts](#concepts)
  * [Centralized Logic](#centralized-logic)
  * [Data Flow](#data-flow)
  * [Explicit Messaging](#explicit-messaging)
* [API](#documentation)
  * [Stores](#stores)
  * [Components](#components)
  * [Applications](#applications)
* [Migrating from space:ui](#migrating-from-spaceui-to-spaceflux)
  * [No Mediators, just Components](#no-mediators-just-components)
  * [Truly Centralized UI Logic](#truly-centralized-ui-logic)
  * [Simplified State Management](#simplified-state-management)
  * [Improved Javascript / ES2015 Compatibility](#improved-javascript-es2015-compatibility)
* [Run the Tests](#run-the-tests)
* [Run the TodoMVC Example](#run-the-todomvc-example)
* [Release History](#release-history)
* [License](#license)

## Installation
`meteor add space:flux`

## Examples
For a quick start take a look at the [TodoMVC example](https://github.com/meteor-space/TodoMVC)

## Concepts
Meteor is a great platform for building real-time apps with Javascript, but for bigger applications the lack of conventions and UI architecture can become a real problem. Templating in Meteor is nice but lacks a lot of architectural patterns. When using the standard templates / managers many people start spreading logic in the view layer, where it becomes hard to manage.

The [Flux architecture](http://facebook.github.io/flux/docs/overview.html) developed by Facebook, solves exactly the same problem for applications built upon [React](http://facebook.github.io/react/) components. Its not a real framework,
more a set of simple conventions and ideas that play well together. `space:flux`
provides these building blocks for your Meteor application.

### Centralized Logic
The core idea of Flux is to centralize the front-end logic into **stores**, the only places where application state is managed. They are what you might call *view model* in other frameworks, except that they don't have to map directly to the concept of a *thing* (e.g: Todo). Stores manage the state of parts of your application. This could be anything, from a `VideoPlaybackStore` that manages the current state of a video player, to a [TodosStore]((https://github.com/meteor-space/TodoMVC/blob/master/javascript/client/stores/todos_store.js) that manages a list of todos.

### Data Flow
The biggest problem with Meteor templates is that they need to get their data
from *somewhere*. Unfortunately there is no good pattern provided by the core
team, so everyone has to come up with custom solutions. `space:flux` integrates
with [blaze-components](https://github.com/peerlibrary/meteor-blaze-components),
by providing a simple API to access reactive application state inside your
components (provided by the stores).

Components hand over state to their managed templates, interpret (dumb) template
events and publish business actions. The stores listen to published actions and
update their internal state according to its logic. The changes are reactively
pushed back to the components that declared their dependency on stores by accessing
their data:

```
╔═════════╗       ╔════════╗  state  ╔════════════════╗  state   ╔══════════════════╗
║  Events ║──────>║ Stores ║────────>║   Components   ║ <──────> ║ Meteor Templates ║
╚═════════╝       ╚════════╝         ╚════════════════╝  events  ╚══════════════════╝
     ^                                      │ publish
     └──────────────────────────────────────┘

```

### Explicit Messaging
Using **pub/sub** messaging between the various layers of your application is an
effective way to decouple them. The *stores* don't know anything about other
parts of the system. *Components* know how to get data from stores and provide
an api to their managed templates. *Templates* don't know anything but to display
given data and dispatch events about user interaction with buttons etc.

Each layer plays an important role and the implementation details can be changed easily.

## API
Only the classes that `space:flux` provides are documented here.
A lot of the basic functionality actually comes from the packages [space:base](https://github.com/meteor-space/base) and [space:messaging](https://github.com/meteor-space/messaging) and are documented there!

### Stores
Stores manage application state, which is then referenced by any number of
components in the application. In most cases this will mean that a store depends
on one or more minimongo collections in your app and constructs queries based
on the view logic of your app. But of course you can also define custom properties
that become a reactive data-source usable in your rendering layer.

### Components

### Applications

## Migrating from space:ui to space:flux
This package was formerly called `space:ui` and used in many applications
around the world. `space:flux` is a completely revisited and refined version
of the APIs (and some of the concepts) which really demanded a new name.

### No Mediators, just Components
We removed our custom view layer (`Space.ui.Mediator` + Meteor templates)
in favor of more popular and recommended alternatives like [blaze-components](https://github.com/peerlibrary/meteor-blaze-components).
In our real world projects we realized that standard Meteor templates just
feel like a big mess and in our opinion you should not build your view layer
only based on that. Mediators did not really improve the situation but just
added another layer of indirection. This is why we dropped them completely.

Take a look at the [TodoList component](https://github.com/meteor-space/ui/blob/develop/examples/TodoMVC/client/views/todo_list/todo_list.js) in the TodoMVC example to see how to use
blaze-components with `space:flux`. You can also read on, as there are examples
shown to indicate how you can refactor your code.

### Truly Centralized UI Logic
The big selling proposition of `space:ui` was that all logic lives within
stores. But the examples actually also showed components / templates managing
their own state. After working on various projects we realized that some
anti patterns emerged and that it is really better to keep all application
state in stores and let high-level components access that reactively. This way
you keep your components completely agnostic about the way state is managed
(could be reactive or not) and you simplify the mental overhead: only one
place is left to work with state. Here is an example that shows the difference:

**Before:** The todo list manages which todo is currently edited
```javascript
// Note: Only the necessary parts of the code are shown here for brevity

Space.ui.Mediator.extend(TodoMVC, 'TodoListMediator', {

  setDefaultState: function() {
    return {
      editingTodoId: null
    };
  },

  editTodo: function(todo) {
    this.set('editingTodoId', todo._id);
  },

  stopEditing: function() {
    this.set('editingTodoId', null);
  }
});
```

**After:** The store receives events from the todo list and manages state
```javascript
// Note: Only the necessary parts of the code are shown here for brevity

Space.flux.BlazeComponent.extend(TodoMVC, 'TodoList', {

  // This modifies the editing state of each todo in the list reactively
  prepareTodoData: function() {
    todo = this.currentData();
    todo.isEditing = this.store.editingTodoId() === todo._id;
    return todo;
  },

  editTodo: function(event) {
    this.publish(new TodoMVC.TodoEditingStarted({
      todoId: this.currentData()._id
    }));
  },

  stopEditing: function() {
    this.publish(new TodoMVC.TodoEditingEnded({
      todoId: this.currentData()._id
    }));
  }

});

Space.flux.Store.extend(TodoMVC, 'TodosStore', {

  reactiveVars: function() {
    return [{
      editingTodoId: null
    }];
  },

  events: function() {
    return [{
      'TodoMVC.TodoEditingStarted': this._setEditingTodoId,
      'TodoMVC.TodoEditingEnded': this._unsetEditingTodoId,
    }];
  },

  _setEditingTodoId: function(event) {
    this.editingTodoId(event.todoId);
  },

  _unsetEditingTodoId: function() {
    this.editingTodoId(null);
  }
});
```

### Simplified State Management
Let's be honest, the previous state API was a mess and complicated things
unnecessarily. Now, the only place where you define state is in instance of `Space.flux.Store`. There are two possibilities:

1. You already have a reactive data source like `Mongo.Collection::find`: in
this case you simply create methods on the store class that return these:
```javascript
Space.flux.Store.extend(TodoMVC, 'TodosStore', {
  completedTodos: function() {
    return this.todos.find({ isCompleted: true });
  }
});
```
2. If you need to manage state that you don't want to hold in a collection
you can use the new API to generate `ReactiveVar` instance accessors:
```javascript
Space.flux.Store.extend(TodoMVC, 'TodosStore', {
  reactiveVars: function() {
    return [{
      activeFilter: this.FILTERS.ALL,
    }];
  },
  filteredTodos: function() {
    // Depend on the reactive value to choose a todos filter
    switch (this.activeFilter()) {
      case this.FILTERS.ALL: return this.todos.find();
      case this.FILTERS.ACTIVE: return this.todos.find({ isCompleted: false});
      case this.FILTERS.COMPLETED: return this.todos.find({ isCompleted: true });
    }
  },
  _changeActiveFilter: function(event) {
    // Set the reactive var to a new value
    this.activeFilter(event.filter);
  }
});
```
This will generate two methods `activeFilter` and `editingTodoId` on your
store instance which can be used to get and set the reactive var.

### Improved Javascript / ES2015 Compatibility
Since `space:ui` was originally developed with Coffeescript, some of the APIs
where only geared toward that style. This created some troubles when using
the framework in Javascript or ES2015. Here is the new declarative event /
command handling API available:

```javascript
Space.flux.Store.extend(TodoMVC, 'TodosStore', {
  // ====== Event handling setup ====== //

  // Map private methods to events coming from the outside
  // this is the only way state can change within the store.

  events: function() {
    return [{
      'TodoMVC.TodoCreated': this._insertNewTodo,
      'TodoMVC.TodoDeleted': this._removeTodo,
      'TodoMVC.TodoEditingStarted': this._setEditingTodoId,
      'TodoMVC.TodoEditingEnded': this._unsetEditingTodoId,
      'TodoMVC.TodoTitleChanged': this._updateTodoTitle,
      'TodoMVC.TodoToggled': this._toggleTodo,
      'TodoMVC.FilterChanged': this._changeActiveFilter
    }];
  },
  // …
});

// This is the same now as with BlazeComponents:
Space.flux.BlazeComponent.extend(TodoMVC, 'TodoList', {
  events: function() {
    return [{
      'toggled .todo': this.toggleTodo,
      'destroyed .todo': this.deleteTodo,
      'doubleClicked .todo': this.editTodo,
      'editingCanceled .todo': this.stopEditing,
      'editingCompleted .todo': this.submitNewTitle,
      'click #toggle-all': this.toggleAllTodos
    }];
  },
});
```

## Run the Tests
`meteor test-packages ./`

## Run the TodoMVC Example
`cd examples/TodoMVC && meteor`

## Release History
You can find the complete release history in the [changelog](https://github.com/meteor-space/flux/blob/master/CHANGELOG.md)

## License
Licensed under the MIT license.
