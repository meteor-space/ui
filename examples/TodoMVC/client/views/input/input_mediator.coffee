
class @InputMediator extends Space.ui.Mediator

  onInputSubmitted: (input) -> @publish new TodoCreated title: input
