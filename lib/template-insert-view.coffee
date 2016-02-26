module.exports =
class TemplateInsertView
  constructor: (serializedState) ->

    @element = document.createElement('div')
    @element.classList.add('template-insert')

    message = document.createElement('div')
    @element.appendChild(message)

  serialize: ->

  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setText: (name,scopeName) ->
    @element.children[0].textContent = name + " scope name: " + scopeName
