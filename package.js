Package.describe({
  summary: 'Meteor UI framework inspired by React and Flux.',
  name: 'space:ui',
  version: '4.1.1',
  git: 'https://github.com/CodeAdventure/space-ui.git'
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'coffeescript',
    'templating',
    'reactive-var',
    'space:base@1.3.2',
    'space:messaging@0.3.2',
  ]);

  api.addFiles([
    'source/module.coffee',
    'source/application.coffee',
    'source/store.coffee',
    'source/mediator.coffee',
    'source/template_mediator_mapping.coffee',
    'source/template_mediator_map.coffee',
    'source/helpers.coffee',
  ], 'client');

});

Package.onTest(function(api) {

  api.use([
    'coffeescript',
    'templating',
    'reactive-var',
    'space:ui',
    'practicalmeteor:munit@2.0.2',
  ]);

  api.addFiles([
    'tests/store.spec.coffee',
    'tests/mediator.spec.coffee',
    'tests/template_mediator_mapping.unit.coffee',
    'tests/template_mediator_map.unit.coffee',
    'tests/greeting_template.integration.html',
    'tests/template_mediator_map.integration.coffee',
  ], 'client');

});
