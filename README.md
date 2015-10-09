# space:ui [![Build Status](https://travis-ci.org/meteor-space/ui.svg?branch=master)](https://travis-ci.org/meteor-space/ui)

**Flexible Meteor UI framework inspired by [React](http://facebook.github.io/react/)
and [Flux](http://facebook.github.io/flux/docs/overview.html).**

## Installation
`meteor add space:ui`

## TodoMVC Example
If you want to know if `space:ui` could be interesting, take a look at
the [TodoMVC example](https://github.com/meteor-space/ui/tree/master/examples/)
It is available in Javascript and Coffeescript.

## Core Ideas
Meteor is a great platform for building realtime apps with Javascript, but for bigger applications the lack of conventions and UI architecture can become a real problem. Templating in Meteor is nice but lacks a lot of architectural patterns. When using the standard templates / managers many people start spreading logic in the view layer, where it becomes hard to manage.

The [Flux architecture](http://facebook.github.io/flux/docs/overview.html) developed by Facebook, solves exactly the same problem for applications built apon [React](http://facebook.github.io/react/) components. Its not a real framework, more a set of simple conventions and ideas that play well together. `space:ui` is a thin layer on top of Meteor and Blaze to provide these building blocks for you!

### Centralized Logic
The core idea of Flux is to centralize the front-end logic into **stores**, the only places where application state is managed. They are what you might call *view model* in other frameworks, except that they don't have to map directly to the concept of a *thing* (e.g: Todo). Stores manage the state of parts of your application. This could be anything, from a `VideoPlaybackStore` that manages the current state of a video player, to a **TodosStore** (see below) that manages a list of todos.

This doesn't mean that they have to be especially complex, here is the whole logic for
managing the todos in the TodoMVC example:

```javascript
Space.ui.Store.extend(TodoMVC, 'TodosStore', {

  FILTERS: {
    ALL: 'all',
    ACTIVE: 'active',
    COMPLETED: 'completed',
  },

  Dependencies: {
    todos: 'TodoMVC.Todos'
  },

  setDefaultState: function() {
    return {
      activeFilter: this.FILTERS.ALL
    };
  },

  setReactiveState: function() {
    return {
      todos: this.todos.find(),
      completedTodos: this.todos.findCompletedTodos(),
      activeTodos: this.todos.findActiveTodos(),
    };
  }
})

.on(TodoMVC.TodoCreated, function(event) {
  this.todos.insert({
    title: event.title,
    isCompleted: false
  });
})

.on(TodoMVC.TodoDeleted, function(event) {
  this.todos.remove(event.todoId);
})

.on(TodoMVC.TodoTitleChanged, function(event) {
  this.todos.update(event.todoId, {
    $set: {
      title: event.newTitle
    }
  });
})

.on(TodoMVC.TodoToggled, function(event) {
  var isCompleted = this.todos.findOne(event.todoId).isCompleted;
  this.todos.update(event.todoId, {
    $set: {
      isCompleted: !isCompleted
    }
  });
})

.on(TodoMVC.FilterChanged, function(event) {
  if (this.get('activeFilter') === event.filter) { return; }
  switch (event.filter) {
    case this.FILTERS.ALL:
      this.set('todos', this.todos.find());
      break;
    case this.FILTERS.ACTIVE:
      this.set('todos', this.todos.find({
        isCompleted: false
      }));
      break;
    case this.FILTERS.COMPLETED:
      this.set('todos', this.todos.find({
        isCompleted: true
      }));
      break;
  }
  this.set('activeFilter', event.filter);
});
```

**Sidenote about the class system**:
`space:ui` is based on [space:base](https://github.com/meteor-space/base) which
provides a very simple but powerful [inheritance system](https://github.com/CodeAdventure/meteor-space/wiki/Space.Object) that
can save you from a lot of typing when using Javascript :wink:

If you are using Coffeescript, you can just extend the framework classes
like normal and use the static class-methods for the setup:

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

# ... you get the point

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

This is the [TodoListMediator](https://github.com/meteor-space/ui/blob/master/examples/TodoMVC/client/views/todo_list/todo_list_mediator.js) for the todo list of the TodoMVC example:

```javascript
Space.ui.Mediator.extend(TodoMVC, 'TodoListMediator', {

  Dependencies: {
    store: 'TodoMVC.TodosStore',
    meteor: 'Meteor',
  },

  setDefaultState: function() {
    return {
      editingTodoId: null
    };
  },

  setReactiveState: function() {
    return {
      todos: this.store.get('todos'),
      hasAnyTodos: this.store.get('todos').count() > 0,
      allTodosCompleted: this.store.get('activeTodos').count() === 0
    };
  },

  toggleTodo: function(todo) {
    this.publish(new TodoMVC.TodoToggled({
      todoId: todo._id
    }));
  },

  deleteTodo: function(todo) {
    this.publish(new TodoMVC.TodoDeleted({ todoId: todo._id }));
  },

  // … abbreviated for this example
});

TodoMVC.TodoListMediator.Template = 'todo_list';
```

And it connects to a standard Meteor template view:

```javascript
Template.todo_list.helpers({
  state: function() {
    return mediator().getState();
  },
  isToggleChecked: function() {
    if (this.hasAnyTodos && this.allTodosCompleted) {
      return 'checked';
    } else {
      return false;
    }
  },
  prepareTodoData: function() {
    this.isEditing = mediator().get('editingTodoId') === this._id;
    return this;
  }
});

Template.todo_list.events({
  'toggled .todo': function(event) {
    return mediator().toggleTodo(getTodo(event));
  },
  'destroyed .todo': function(event) {
    return mediator().deleteTodo(getTodo(event));
  }
  // … abbreviated for this example
});

// helpers
function mediator() {
  return Space.ui.getMediator();
}

function getTodo(event) {
  return Space.ui.getEventTarget(event).data;
}
```

#### Integration with blaze-components

You are not limited to the standard Meteor templates, `space:ui` also fully
integrates with the fantastic [blaze-components](https://github.com/peerlibrary/meteor-blaze-components)
package via the `Space.ui.BlazeComponent` class.

Here is the footer component of the TodoMVC example:

```javascript
Space.ui.BlazeComponent.extend(TodoMVC, 'FooterComponent', {

  Dependencies: {
    store: 'TodoMVC.TodosStore',
    meteor: 'Meteor'
  },

  setDefaultState: function() {
    return {
      availableFilters: this._mapAvailableFilters()
    };
  },

  setReactiveState: function() {
    return {
      activeTodosCount: this.store.get('activeTodos').count(),
      completedTodosCount: this.store.get('completedTodos').count()
    };
  },

  pluralize: function(count) {
    if(count === 1) {
      return 'item';
    }
    else {
      return 'items';
    }
  },

  events: function() {
    return [{
      'click #clear-completed': function(event) {
        this.meteor.call('clearCompletedTodos');
      }
    }];
  },

  _mapAvailableFilters: function() {
    return _.map(this.store.FILTERS, function(key) {
      return {
        name: key[0].toUpperCase() + key.slice(1),
        path: key
      };
    });
  }
})

.register('footer'); // BlazeComponent API to register with template
```

And here the same in Coffeescript, since the BlazeComponents api is optimized
for that:

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

```javascript
Space.messaging.Controller.extend(TodoMVC, 'LayoutController', {
  Dependencies: {
    layout: 'FlowLayout'
  }
})

.on(TodoMVC.FilterRouteTriggered, function(event) {
  this.layout.render("index");
});

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

```javascript
TodoMVC = Space.ui.Application.extend('TodoMVC', {

  RequiredModules: ['Space.ui'],
  Stores: ['TodoMVC.TodosStore'],
  Mediators: ['TodoMVC.TodoListMediator'],
  Components: ['TodoMVC.InputComponent', 'TodoMVC.FooterComponent'],
  Controllers: ['TodoMVC.RouteController', 'TodoMVC.LayoutController'],
  Singletons: ['TodoMVC.TodosTracker'],

  Dependencies: {
    eventBus: 'Space.messaging.EventBus'
  },

  publish: function(event) {
    this.eventBus.publish(event);
  }
});
```

## Run the tests
`meteor test-packages ./`

## Run the example TodoMVC
`cd examples/TodoMVC && meteor`

## Release History
You can find the complete release history in the [changelog](https://github.com/meteor-space/ui/blob/master/CHANGELOG.md)

## License
Licensed under the MIT license.
