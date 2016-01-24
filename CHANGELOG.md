Changelog
=========

## 6.0.0
This major version has been months in the works, and we're excited to be introducing Version 6 as a simplification of APIs and separation of concerns.

With this release we see _flux_ concepts extracted into a dedicated package [space:flux](https://github.com/meteor-space/flux), allowing `space:ui` to provide pattern-agnostic UI base features suitable for tailored implementations. Installing `space:flux` will install `space:ui`, but if _flux_ or our implementation is not what you're looking for, just use `space:ui` instead. Too easy!

We're now 100% focused on ES6, and have introduced declarative APIs as the original Coffeescript style didn't translate well. View the complete [TodoMVC](https://github.com/meteor-space/TodoMVC/tree/develop/javascript) example here to get a feel for the new style

State APIs have been unified into `Space.ui.Stateful`; an object added as a mixin. There are three types of state it can manage:



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

### New Features:
- `Space.ui.Event` is an extension of `Space.messaging.Event`
Currently this is just a more expressive object, but any future UI specific 
event features will be added here and not the base class.

### Breaking Changes:
- This version uses space:base 4.x which includes breaking changes. 
Please see the [changelog](https://github.com/meteor-space/base/blob/master/CHANGELOG.md).
- This version uses space:messaging 3.x which includes breaking changes. 
Please see the [changelog](https://github.com/meteor-space/messaging/blob/master/CHANGELOG.md).

- Must be running Meteor 1.2.0.1 or later.
- `Space.ui.Store` has been extracted to a separate package [space:flux](https://github.com/meteor-space/flux/)
- Reactive data sources now just need to be defined as methods on `Space.flux.Store`,
 with non-reactive sources returned in `reactiveVars` or `sessionVars`.
  This change was motivated to simplify the component's interface, but it also improves
   the clarity of reactive state management in the store.
- `Space.ui.Mediator` was removed from the project in favour of more popular and
recommended alternatives like blaze-components. 


### Upgrade from 5.x
- Please see the migration guide in [space:base](https://github.com/meteor-space/base/blob/master/README.md#migration-guide)

- `meteor add space:flux`
- Switch base object `Space.ui.Store` to `Space.flux.Store`
- Replace any `Space.ui.Mediator` and standard 'template managers' with a
 `Space.ui.BlazeComponent` (Example: [TodoList component](https://github.com/meteor-space/ui/blob/develop/examples/TodoMVC/client/views/todo_list/todo_list.js)) 
- Change all `Space.flux.Store` event subscribers to the new declarative
 `eventSubscriptions` API.
- Ensure all store state is either determined via a method (if already reactive),
 or is part of `reactiveVars` or `sessionVars` (a store scoped reactiveDict).

Further detail can be seen in
 [TodosMVC](https://github.com/meteor-space/TodoMVC/tree/develop/javascript) sample app

## 5.3.0
Updates to latest `space:base` and `space:messaging` packages.

## 5.2.1
Updated Github location to point to new home at https://github.com/meteor-space/ui

## 5.2.0
Updates to latest `space:base` and `space:messaging` packages which introduced
many small debugging and API improvements.

## 5.1.3
Throw better errors when blaze components could not be resolved.

## 5.1.2
Let mediators and blaze components cleanup their state on destruction

## 5.1.1
Adds weak dependency on blaze-components package so that it work in a package
only app.

## 5.1.0
Introduces support for `blaze-components` via the new class `Space.ui.BlazeComponent`. This works very similar to `Space.ui.Mediator`
but it also extends `BlazeComponent` with all its capabilities.
See the TodoMVC example for a basic reference.

## 5.0.2
Adds support for Meteor > 1.0 template hooks.

## 5.0.1
@Sanjo fixed a minor issue #29 with `Space.ui.createEvents`

## 5.0.0
Updates to `space:base@2.0.0` and `space:messaging@1.0.0` (checkout breaking
changes in both packages!). Here is short summary:

### Upgrade from 4.x
- replace the app/module `run` hook with `startup`
- start your application with `start` instead of `run`
- There is a new `Space.messaging.Api` to define Meteor methods that can be
tested easily. This **replaces** the functionality from `Space.messaging.CommandBus`
to send commands from client to server. **This is not possible anymore!**
Commands are now just the same as events, you can use them on the client side
and server side the same way, **BUT** if you want "type safety" when sending
a command from client to server, you have to check it yourself within the server
method. See the updated TodoMVC example.

## 4.3.2
Introduces the concept of non-reactive default state for stores and mediators
so that state is not always overwritten by default values when some reactive
dependency triggers a re-run of the `setInitialState` method. If you have default
values for the state use `setDefaultState` instead. This method is only run once
when the instance is created, after the dependencies were injected.

## 4.3.1
Make setting the initial state of stores and mediators reactive. This has the
benefit that one can take advantage of `Mongo.Collection#findOne` and other reactivity
features when initializing the state.

## 4.3.0
Use the new `Space.Object.mixin` capabilities to introduce the `Space.ui.Stateful`
mixin that encapsulates the state setting functionality that the store had and make
it available on mediators too.

## 4.2.1
Introduce Space.ui.Module with same mapping automation features as the previously
added Space.ui.Application

## 4.2.0
Updates to latest space package dependencies, especially to `space:messaging`
which introduced a simpler controller api for handling messages.

## 4.1.1
Fixes bug with reactivity when setting store state via `set`. It is non-reactive now.

## 4.1.0
Adds `Space.ui.Application` class with simplified api for setting up stores,
mediators and controllers.

## 4.0.1
Use latest space:messaging release

## 4.0.0

- Upgrades to `space:base@1.3.0`

### Upgrade from 3.x
Replace the flux dispatcher and actions with more solid event architecture
called `space:messaging`. This also introduces type-checked events. Please
have a look at the TodoMVC example to see how the new system works.

## 3.4.4
Upgrades to `space:base@1.2.6`

## 3.4.3
Adds tests for store `state` related methods and improves its API

## 3.4.2
Upgrades to `space:base@1.2.4`

## 3.4.0
Removes iron-router suppport and its dependency on it.

## 3.3.0
Improves the Mediator api for creating template helpers and event handlers.

## 3.2.0
Adds simplified api for creating and dispatching actions (see TodoMVC example).

## 3.1.0
Introduces auto-mapping of mediators and templates via annotations.

## 3.0.0
Cleans up the mediator API and removed old relicts that are not used anymore.

## 2.0.0
Update to the latest 1.0.3 verison of iron:router and fast-render packages.

## 1.0.0
Publish first version to Meteor package system.
