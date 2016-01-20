Space.Object.extend('Space.flux.Store', {
  mixin: [
    Space.flux.Stateful,
    Space.flux.Reactive,
    Space.messaging.EventSubscribing
  ]
});
