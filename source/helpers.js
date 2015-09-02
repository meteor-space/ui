Space.ui.getEventTarget = function(event) {
  return event.target.$blaze_range.view.templateInstance();
};

Space.ui.getMediator = function() {
  return Template.instance().mediator;
};
