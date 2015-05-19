Package.describe({
  summary: 'Meteor UI framework inspired by React and Flux.',
  name: 'space:ui',
  version: '5.0.2',
  git: 'https://github.com/CodeAdventure/space-ui.git'
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'coffeescript',
    'underscore',
    'templating',
    'reactive-var',
    'space:base@2.0.0',
    'space:messaging@1.0.0',
  ]);

  api.addFiles([
    'source/module.coffee',
    'source/automation.coffee',
    'source/stateful.coffee',
    'source/store.coffee',
    'source/mediator.coffee',
    'source/blaze_component.coffee',
    'source/template_mediator_mapping.coffee',
    'source/template_mediator_map.coffee',
    'source/helpers.coffee',
  ], 'client');

});

Package.onTest(function(api) {

  api.use([
    'coffeescript',
    'underscore',
    'templating',
    'reactive-var',
    'space:ui',
    'practicalmeteor:munit@2.1.4',
    'space:testing@1.3.0'
  ]);

  api.addFiles([
    'tests/stateful.spec.coffee',
    'tests/store.spec.coffee',
    'tests/mediator.spec.coffee',
    'tests/template_mediator_mapping.unit.coffee',
    'tests/template_mediator_map.unit.coffee',
    'tests/greeting_template.integration.html',
    'tests/template_mediator_map.integration.coffee',
  ], 'client');

});
