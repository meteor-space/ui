Package.describe({
  summary: 'Pattern-agnostic base UI package to gain control over your Meteor UI',
  name: 'space:ui',
  version: '6.0.0',
  git: 'https://github.com/meteor-space/ui.git'
});

Package.onUse(function(api) {

  api.versionsFrom('1.2.0.1');

  api.use([
    'underscore',
    'templating',
    'tracker',
    'ecmascript',
    'reactive-var',
    'reactive-dict',
    'space:base@4.0.0',
    'space:messaging@3.0.0'
  ]);

  api.use([
    'peerlibrary:blaze-components@0.15.0'
  ], 'client', {weak: true});

  api.addFiles([
    'source/module.js',
    'source/automation.js',
    'source/mixins/stateful.js',
    'source/mixins/reactive.js',
    'source/blaze_component.js',
    'source/helpers.js',
    'source/event.js'
  ], 'client');

});

Package.onTest(function(api) {

  api.use([
    'ecmascript',
    'space:ui',
    'reactive-var',
    'tracker',
    'practicalmeteor:munit@2.1.5',
    'space:testing@3.0.1'
  ]);

  api.addFiles([
    'tests/reactive.tests.js',
    'tests/event.tests.js'
  ], 'client');

});
