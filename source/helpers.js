Space.ui.getEventTarget = function(event) {
  return event.target.$blaze_range.view.templateInstance();
};

Space.ui.defineEvents = function() {
  let args = Array.prototype.slice.call(arguments);
  args.unshift(Space.ui.Event);
  return Space.messaging.define.apply(this, args);
};
