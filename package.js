Package.describe({
  summary: 'Meteor UI framework inspired by React and Flux.',
  name: 'space:ui',
  version: '3.4.4',
  git: 'https://github.com/CodeAdventure/space-ui.git'
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'coffeescript',
    'templating',
    'reactive-var',
    'space:base@1.2.6',
  ]);

  api.addFiles([
    'source/module.coffee',
  ]);

  api.addFiles([

    // FLUX
    'source/flux/dispatcher.coffee',
    'source/flux/messenger.coffee',
    'source/flux/store.coffee',
    'source/flux/action_factory.coffee',

    // MEDIATORS
    'source/mediators/mediator.coffee',
    'source/mediators/template_mediator_mapping.coffee',
    'source/mediators/template_mediator_map.coffee',
    'source/mediators/template.html',
    'source/mediators/template.coffee',

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
    // mediators
    'tests/mediators/template_mediator_mapping.unit.coffee',
    'tests/mediators/template_mediator_map.unit.coffee',
    'tests/mediators/greeting_template.integration.html',
    'tests/mediators/template_mediator_map.integration.coffee',
    // flux
    'tests/flux/store.spec.coffee',
  ], 'client');

});
