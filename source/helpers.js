/**
 * Helper method to define event classes on an (optional) namespace
 * with given Space.Struct properties which are checked during runtime:
 *
 * Space.ui.createEvents('my.namespace', {
 *   SomethingHappened: {
 *     firstProp: String
 *     anotherProp: Match.Integer
 *   },
 *   AnotherEventType: { … }
 * });
 */
Space.ui.createEvents = function(namespace, events) {

  // Namespace is optional
  if(events === undefined) {
    events = namespace;
    namespace = '';
  }

  // Start at the last object of the namespace
  var parent = Space.resolvePath(namespace),
      fields = null;

  for(var key in events) {
    fields = events[key];
    // Assign static EJSON related type and runtime-checked fields
    parent[key] = Space.messaging.Event.extend(function() {
      this.type(namespace + '.' + key);
      this.fields = fields;
      return this;
    });
  }
};

Space.ui.getEventTarget = function(event) {
  return event.target.$blaze_range.view.templateInstance();
};

Space.ui.getMediator = function() {
  return Template.instance().mediator;
};
