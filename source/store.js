
Space.Object.extend(Space.flux, 'Store', {
  mixin: [
    Space.flux.Stateful,
    Space.messaging.EventSubscribing
  ]
});
