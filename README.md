# space:ui [![Build Status](https://travis-ci.org/meteor-space/ui.svg?branch=master)](https://travis-ci.org/meteor-space/ui)

**Flexible Meteor UI framework inspired by [React](http://facebook.github.io/react/)
and [Flux](http://facebook.github.io/flux/docs/overview.html).**

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
* [Run the Tests](#run-the-tests)
* [Run the TodoMVC Example](#run-the-todomvc-example)
* [Release History](#release-history)
* [License](#license)

## Installation
`meteor add space:ui`

## Examples
For a quick start take a look at the [TodoMVC example](https://github.com/meteor-space/ui/tree/master/examples/)
It is available in Javascript and Coffeescript.

## Concepts
Meteor is a great platform for building realtime apps with Javascript, but for bigger applications the lack of conventions and UI architecture can become a real problem. Templating in Meteor is nice but lacks a lot of architectural patterns. When using the standard templates / managers many people start spreading logic in the view layer, where it becomes hard to manage.

The [Flux architecture](http://facebook.github.io/flux/docs/overview.html) developed by Facebook, solves exactly the same problem for applications built apon [React](http://facebook.github.io/react/) components. Its not a real framework,
more a set of simple conventions and ideas that play well together. `space:ui`
provides these building blocks for your Meteor application.

### Centralized Logic
The core idea of Flux is to centralize the front-end logic into **stores**, the only places where application state is managed. They are what you might call *view model* in other frameworks, except that they don't have to map directly to the concept of a *thing* (e.g: Todo). Stores manage the state of parts of your application. This could be anything, from a `VideoPlaybackStore` that manages the current state of a video player, to a [TodosStore]((https://github.com/meteor-space/ui/blob/master/examples/TodoMVC/client/stores/todos_store.js) that manages a list of todos.

### Data Flow
The biggest problem with Meteor templates is that they need to get their data
from *somewhere*. Unfortunately there is no good pattern provided by the core
team, so everyone has to come up with custom solutions. `space:ui` integrates
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
Only the classes that `space:ui` provides are documented here.
A lot of the basic functionality actually comes from the packages [space:base](https://github.com/meteor-space/base) and [space:messaging](https://github.com/meteor-space/messaging) and are documented there!

### Stores
Stores manage application state, which is then referenced by any number of
components in the application. In most cases this will mean that a store depends
on one or more minimongo collections in your app and constructs queries based
on the view logic of your app. But of course you can also define custom properties
that become a reactive data-source usable in your rendering layer.

### Components

### Applications

## Run the Tests
`meteor test-packages ./`

## Run the TodoMVC Example
`cd examples/TodoMVC && meteor`

## Release History
You can find the complete release history in the [changelog](https://github.com/meteor-space/ui/blob/master/CHANGELOG.md)

## License
Licensed under the MIT license.
