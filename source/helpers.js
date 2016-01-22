Space.flux.getEventTarget = function(event) {
  return event.target.$blaze_range.view.templateInstance();
};

Space.flux.defineEvents = function() {
  let args = Array.prototype.slice.call(arguments);
  args.unshift(Space.flux.Event);
  return Space.messaging.define.apply(this, args);
};
