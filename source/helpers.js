Space.flux.getEventTarget = function(event) {
  return event.target.$blaze_range.view.templateInstance();
};

Space.flux.defineEvents = function() {
  var args = Array.prototype.slice.call(arguments);
  args.unshift(Space.messaging.Event);
  return Space.messaging.define.apply(this, args);
};
