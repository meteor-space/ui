Space.ui.getEventTarget = function(event) {
  return event.target.$blaze_range.view.templateInstance();
};

Space.ui.getMediator = function() {
  return Template.instance().mediator;
};

Space.ui.createEvents = function() {
  var args = Array.prototype.slice.call(arguments);
  args.unshift(Space.messaging.Event);
  return Space.messaging.define.apply(this, args);
};
