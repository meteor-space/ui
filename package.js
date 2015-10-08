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
