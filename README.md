# Space UI [![Circle CI](https://circleci.com/gh/meteor-space/ui.svg?style=svg)](https://circleci.com/gh/meteor-space/ui)

_Pattern-agnostic base UI package to gain control over your Meteor UI_

### Table of Contents:
* [Installation](#installation)
* [Examples](#examples)
* [Concepts](#concepts)
  * [Centralized Logic](#centralized-logic)
  * [Data Flow](#data-flow)
  * [Explicit Messaging](#explicit-messaging)
* [API](#documentation)
  * [Components](#components)
  * [Applications](#applications)
* [Version 6](#version-6)
  * [Flux is optional now](#flux-is-optional-now)
  * [No Mediators, just Components](#no-mediators-just-components)
  * [Truly Centralized UI Logic](#truly-centralized-ui-logic)
  * [Simplified State Management](#simplified-state-management)
  * [Improved Javascript / ES2015 Compatibility](#improved-javascript-es2015-compatibility)
* [Run the Tests](#run-the-tests)
* [Run the TodoMVC Example](#run-the-todomvc-example)
* [Release History](#release-history)
* [License](#license)

## Installation
`meteor add space:ui`

Package `peerlibrary:blaze-components` is needed in order to use `Space.ui.BlazeComponent`:

`meteor add peerlibrary:blaze-components`

## Examples
For a quick start take a look at the [TodoMVC example](https://github.com/meteor-space/TodoMVC)

## Concepts
Meteor is a great platform for building real-time apps with Javascript, but for bigger applications the lack of conventions and UI architecture can become a real problem. Templating in Meteor is nice but lacks a lot of architectural patterns. When using the standard templates / managers many people start spreading logic in the view layer, where it becomes hard to manage.

space:ui provides the base functionality for specific UI pattern packages like our [space:flux](https://github.com/meteor-space/flux) package.

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

### Components

### Applications

## Version 6
This major version has been months in the works, and we're excited to be introducing Version 6 as a simplification of APIs and separation of concerns.

### Flux is optional now
With this release we see _flux_ concepts extracted into a dedicated package [space:flux](https://github.com/meteor-space/flux), allowing `space:ui` to provide pattern-agnostic UI base features suitable for tailored implementations. Installing `space:flux` will install `space:ui`, but if _flux_ or our implementation is not what you're looking for, just use `space:ui` instead. Too easy!


### No Mediators, just Components
We removed our custom view layer (`Space.ui.Mediator` + Meteor templates)
in favor of more popular and recommended alternatives like [blaze-components](https://github.com/peerlibrary/meteor-blaze-components).
In our real world projects we realized that standard Meteor templates just
feel like a big mess and in our opinion you should not build your view layer
only based on that. Mediators did not really improve the situation but just
added another layer of indirection. This is why we dropped them completely.

Take a look at the [TodoList component](https://github.com/meteor-space/ui/blob/develop/examples/TodoMVC/client/views/todo_list/todo_list.js) in the TodoMVC example to see how to use
blaze-components. You can also read on, as there are examples
shown to indicate how you can refactor your code.

### Simplified State Management
Let's be honest, the previous state API was a mess and complicated things
unnecessarily. There is now just `Space.ui.Stateful`, an object used to mixin an interface where state should be managed. There are three types of state it can manage:



- 1. You already have a reactive data source like `Mongo.Collection::find`: in
this case you simply create methods on the class that return these:

```javascript
Space.flux.Store.extend(TodoMVC, 'TodosStore', {
  completedTodos: function() {
    return this.todos.find({ isCompleted: true });
  }
});

```
- 2. If you need to manage state that you don't want to hold in a collection
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

- 3. If you need to manage state that you don't want to hold in a collection, and you need the values to persist during a hot-code push use the new sessionVars API to generate a scoped `ReactiveDict` instance accessor:

```javascript
Space.flux.Store.extend(TodoMVC, 'TodosStore', {
  sessionVars() {
    return [{
      editingTodoId: null
    }];
  },

  eventSubscriptions() {
    return [{
      'TodoMVC.TodoEditingStarted': this._setEditingTodoId,
      'TodoMVC.TodoEditingEnded': this._unsetEditingTodoId,
    }];
  },

  _setEditingTodoId(event) {
    this._setSessionVar('editingTodoId', event.todoId);
  },

  _unsetEditingTodoId() {
    this._setSessionVar('editingTodoId', null);
  }

});
```
`Space.ui.BlazeComponent` is `Stateful`

```javascript
Space.ui.BlazeComponent.extend('TodoMVC.MyCustomComponent', {
  _session: 'TodoMVC.MyCustomComponent', // some unique name for session
  sessionVars() {
    return [{ mySessionVar: null }]; // default value
  },
  reactiveVars() {
    return [{ someReactiveVar: null }]; // default value
  }
});
```

### Improved Javascript / ES6 Compatibility
We're now 100% focused on ES6, and have introduced declarative APIs as the original Coffeescript style didn't translate well. View the complete [TodoMVC](https://github.com/meteor-space/TodoMVC/tree/develop/javascript) example here to get a feel for the new style


## Run the Tests
`meteor test-packages ./`

## Run the TodoMVC Example
`cd examples/TodoMVC && meteor`

## Release History
You can find the complete release history in the [changelog](https://github.com/meteor-space/flux/blob/master/CHANGELOG.md)

## License
Licensed under the MIT license.
