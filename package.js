Package.describe({
  summary: 'Meteor UI framework inspired by React and Flux.',
  name: 'space:ui',
  version: '5.3.0',
  git: 'https://github.com/meteor-space/ui.git'
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'underscore',
    'templating',
    'tracker',
    'reactive-var',
    'space:base@2.4.2',
    'space:messaging@1.7.1',
  ]);

  api.use([
    'peerlibrary:blaze-components@0.13.0'
  ], 'client', {weak: true});

  api.addFiles([
    'source/module.js',
    'source/automation.js',
    'source/stateful.js',
    'source/store.js',
    'source/blaze_component.js',
    'source/helpers.js',
  ], 'client');

});

Package.onTest(function(api) {

  api.use([
    'coffeescript',
    'underscore',
    'templating',
    'reactive-var',
    'tracker',
    'space:ui',
    'practicalmeteor:munit@2.1.4',
    'space:testing@1.3.0'
  ]);

  api.addFiles([
  ], 'client');

});
