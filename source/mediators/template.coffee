
Template.template.helpers

  chooseTemplate: (name) -> Template[name]

  prepareData: (context, data) ->

    if not data? then data = {}
    data.templateMediatorContext = context
    return data
