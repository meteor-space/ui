
class @InputMediator extends Space.ui.Mediator

  @Template: 'input'

  onInputSubmitted: (input) -> @publish new TodoCreated title: input
