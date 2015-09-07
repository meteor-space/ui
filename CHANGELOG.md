Changelog
=========

### 5.2.1
Updated Github location to point to new home at https://github.com/meteor-space/ui

### 5.2.0
Updates to latest `space:base` and `space:messaging` packages which introduced
many small debugging and API improvements.

### 5.1.3
Throw better errors when blaze components could not be resolved.

### 5.1.2
Let mediators and blaze components cleanup their state on destruction

### 5.1.1
Adds weak dependency on blaze-components package so that it work in a package
only app.

### 5.1.0
Introduces support for `blaze-components` via the new class `Space.ui.BlazeComponent`. This works very similar to `Space.ui.Mediator`
but it also extends `BlazeComponent` with all its capabilities.
See the TodoMVC example for a basic reference.

### 5.0.2
Adds support for Meteor > 1.0 template hooks.

### 5.0.1
@Sanjo fixed a minor issue #29 with `Space.ui.createEvents`

### 5.0.0
Updates to `space:base@2.0.0` and `space:messaging@1.0.0` (checkout breaking
changes in both packages!). Here is short summary:

#### Upgrade from 4.0
- replace the app/module `run` hook with `startup`
- start your application with `start` instead of `run`
- There is a new `Space.messaging.Api` to define Meteor methods that can be
tested easily. This **replaces** the functionality from `Space.messaging.CommandBus`
to send commands from client to server. **This is not possible anymore!**
Commands are now just the same as events, you can use them on the client side
and server side the same way, **BUT** if you want "type safety" when sending
a command from client to server, you have to check it yourself within the server
method. See the updated TodoMVC example.

### 4.3.2
Introduces the concept of non-reactive default state for stores and mediators
so that state is not always overwritten by default values when some reactive
dependency triggers a re-run of the `setInitialState` method. If you have default
values for the state use `setDefaultState` instead. This method is only run once
when the instance is created, after the dependencies were injected.

### 4.3.1
Make setting the initial state of stores and mediators reactive. This has the
benefit that one can take advantage of `Mongo.Collection#findOne` and other reactivity
features when initializing the state.

### 4.3.0
Use the new `Space.Object.mixin` capabilities to introduce the `Space.ui.Stateful`
mixin that encapsulates the state setting functionality that the store had and make
it available on mediators too.

### 4.2.1
Introduce Space.ui.Module with same mapping automation features as the previously
added Space.ui.Application

### 4.2.0
Updates to latest space package dependencies, especially to `space:messaging`
which introduced a simpler controller api for handling messages.

### 4.1.1
Fixes bug with reactivity when setting store state via `set`. It is non-reactive now.

### 4.1.0
Adds `Space.ui.Application` class with simplified api for setting up stores,
mediators and controllers.

### 4.0.1
Use latest space:messaging release

### 4.0.0

Upgrades:
---------
- Upgrades to `space:base@1.3.0`

Breaking Changes:
----------------
Replace the flux dispatcher and actions with more solid event architecture
called `space:messaging`. This also introduces type-checked events. Please
have a look at the TodoMVC example to see how the new system works.

### 3.4.4
Upgrades to `space:base@1.2.6`

### 3.4.3
Adds tests for store `state` related methods and improves its API

### 3.4.2
Upgrades to `space:base@1.2.4`

### 3.4.0
Removes iron-router suppport and its dependency on it.

### 3.3.0
Improves the Mediator api for creating template helpers and event handlers.

### 3.2.0
Adds simplified api for creating and dispatching actions (see TodoMVC example).

### 3.1.0
Introduces auto-mapping of mediators and templates via annotations.

### 3.0.0
Cleans up the mediator API and removed old relicts that are not used anymore.

### 2.0.0
Update to the latest 1.0.3 verison of iron:router and fast-render packages.

### 1.0.0
Publish first version to Meteor package system.
