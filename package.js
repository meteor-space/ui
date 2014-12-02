Package.describe({
  summary: 'Reactive UI based on Iron Router and the Flux architecture.',
  name: 'space:ui',
  version: '2.0.2',
  git: 'https://github.com/CodeAdventure/space-ui.git'
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'coffeescript',
    'templating',
    'reactive-var',

    'space:base@1.1.0',
    'iron:router@1.0.3',
    'meteorhacks:fast-render@2.0.2',
    'tmeasday:html5-history-api@4.0.0',
  ]);

  api.addFiles([
    'source/module.coffee',
  ]);

  api.addFiles([

    // FLUX
    'source/flux/dispatcher.coffee',
    'source/flux/action_handler.coffee',
    'source/flux/action_dispatcher.coffee',
    'source/flux/store.coffee',
    'source/flux/repository.coffee',
    'source/flux/view_controller.coffee',

    // MEDIATORS
    'source/mediators/template_mediator_mapping.coffee',
    'source/mediators/template_mediator_map.coffee',
    'source/mediators/template.html',
    'source/mediators/template.coffee',

    // ROUTING
    'source/routing/route_controller.coffee',

  ], 'client');

});

Package.onTest(function(api) {

  api.use([
    'coffeescript',
    'templating',
    'reactive-var',

    // needed to test mappings
    'iron:router',
    'meteorhacks:fast-render',

    'space:ui',
    'spacejamio:munit@2.0.2',
  ]);

  api.addFiles([
    'tests/configuration.coffee'
  ]);

  api.addFiles([
    'tests/routing/route_controller.unit.coffee',
    'tests/mediators/template_mediator_mapping.unit.coffee',
    'tests/mediators/template_mediator_map.unit.coffee',
    'tests/mediators/greeting_template.integration.html',
    'tests/mediators/template_mediator_map.integration.coffee'
  ], 'client');

  api.addFiles([
    'tests/routing/fast_render.integration.coffee',
    'tests/routing/iron_router.integration.coffee',
  ]);

});
