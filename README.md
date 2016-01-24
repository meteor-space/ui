# Space UI [![Circle CI](https://circleci.com/gh/meteor-space/ui.svg?style=svg)](https://circleci.com/gh/meteor-space/ui)

_Pattern-agnostic base UI package to gain control over your Meteor UI_

### Table of Contents:
* [Installation](#installation)
* [Examples](#examples)
* [API](#documentation)
  * [Components](#components)
  * [Applications](#applications)
* [Run the Tests](#run-the-tests)
* [Run the TodoMVC Example](#run-the-todomvc-example)
* [Release History](#release-history)
* [License](#license)

## Installation
1. `meteor add space:ui`
2. `meteor add peerlibrary:blaze-components`
3. Optional: `meteor add space:flux`


## Examples
For a quick start take a look at the [TodoMVC example](https://github.com/meteor-space/TodoMVC)

## API
Only the classes that `space:ui` provides are documented here. 
A lot of the basic functionality comes from the following 
self-documented packages:
- [space:base](https://github.com/meteor-space/base)
- [space:messaging](https://github.com/meteor-space/messaging)

### Space.Module additional properties
#### controllers

#### components

### Classes

#### Space.ui.Component

#### Space.ui.BlazeComponent

#### Space.ui.Event

### Mixins
#### Space.ui.Reactive

#### Space.ui.Stateful 

### Helpers
#### Space.ui.getEventTarget

#### Space.ui.defineEvents

## Run the Tests
`meteor test-packages ./`

## Run the TodoMVC Example
`cd examples/TodoMVC && meteor`

## Release History
You can find the complete release history in the [changelog](https://github.com/meteor-space/flux/blob/master/CHANGELOG.md)

## License
Licensed under the MIT license.
