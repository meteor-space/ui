Package.describe({
  summary: 'Manage application UI state using Flux patterns specific to Meteor',
  name: 'space:flux',
  version: '1.0.0',
  git: 'https://github.com/meteor-space/flux.git'
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
    'source/store.js',
    'source/blaze_component.js',
    'source/helpers.js',
    'source/flux-event.js'
  ], 'client');

});

Package.onTest(function(api) {

  api.use([
    'ecmascript',
    'space:flux',
    'reactive-var',
    'tracker',
    'practicalmeteor:munit@2.1.5',
    'space:testing@3.0.1',
    'space:testing-messaging@3.0.0',
    'space:testing-flux@1.0.0'
  ]);

  api.addFiles([
    'tests/store.tests.js',
    'tests/reactive.tests.js'
  ], 'client');

});
