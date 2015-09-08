
InputComponent = Space.ui.BlazeComponent.extend('InputComponent', {

  events: function() {
    return [{
      'keyup #new-todo': function(event) {
        // When it was the ENTER key
        if(event.keyCode === 13) {
          // Tell mediator about it
          var input = this.$('#new-todo').val();
          this.publish(new TodoCreated({ title: input}));
          // Reset input
          this.$('#new-todo').val('');
        }
      }
    }];
  }

})
.register('input'); // BlazeComponent API to register with template
