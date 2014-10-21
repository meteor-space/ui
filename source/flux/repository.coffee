
class Space.ui.Repository extends Space.ui.ActionDispatcher

  generateGuid: ->

    time = new Date().getTime()

    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (current) ->

      random = (time + Math.random()*16) % 16 | 0
      time = Math.floor time / 16
      char = if current == 'x' then random else (random&0x7|0x8)

      return char.toString 16