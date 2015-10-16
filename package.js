Package.describe({
  summary: 'Manage application UI state using Flux patterns specific to Meteor',
  name: 'space:flux',
  version: '0.6.0',
  git: 'https://github.com/meteor-space/flux.git'
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'underscore',
    'templating',
    'tracker',
    'reactive-var',
    'reactive-dict',
    'space:base@2.4.2',
    'space:messaging@1.7.2',
  ]);

  api.use([
    'peerlibrary:blaze-components@0.13.0'
  ], 'client', {weak: true});

  api.addFiles([
    'source/module.js',
    'source/automation.js',
    'source/store.js',
    'source/blaze_component.js',
    'source/helpers.js',
  ], 'client');

});
