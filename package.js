Package.describe({
  summary: 'Meteor UI framework inspired by React and Flux.',
  name: 'space:ui',
  version: '5.3.0',
  git: 'https://github.com/meteor-space/ui.git'
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'coffeescript',
    'underscore',
    'templating',
    'reactive-var',
    'space:base@2.4.0',
    'space:messaging@1.7.0',
  ]);

  api.use([
    'peerlibrary:blaze-components@0.9.2'
  ], 'client', {weak: true});

  api.addFiles([
    'source/module.js',
    'source/automation.js',
    'source/stateful.js',
    'source/store.coffee',
    'source/mediator.coffee',
    'source/blaze_component.js',
    'source/template_mediator_mapping.coffee',
    'source/template_mediator_map.coffee',
    'source/helpers.js',
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
