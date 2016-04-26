TemplateInsertView = require './template-insert-view'
Config = require './config'
Replacer = require './replacer'
{CompositeDisposable} = require 'atom'

module.exports = TemplateInsert =
  templateInsertView: null
  modalPanel: null
  subscriptions: null
  config: new Config().get()
  insert: null

  activate: (state) ->
    @templateInsertView = new TemplateInsertView(state.templateInsertViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @templateInsertView.getElement(), visible: false)
    @replacer = new Replacer
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'template-insert:toggle': => @toggle()
      'template-insert:insert1': => @replacer.insert(1,false)
      'template-insert:insert2': => @replacer.insert(2,false)
      'template-insert:insert3': => @replacer.insert(3,false)
      'template-insert:insert4': => @replacer.insert(4,false)
      'template-insert:insert5': => @replacer.insert(5,false)
      'template-insert:insert6': => @replacer.insert(6,false)
      'template-insert:insert7': => @replacer.insert(7,false)
      'template-insert:insert8': => @replacer.insert(8,false)
      'template-insert:insert9': => @replacer.insert(9,false)
      'template-insert:insert0': => @replacer.insert(0,false)
      'template-insert:insert1g': => @replacer.insert(1,true)
      'template-insert:insert2g': => @replacer.insert(2,true)
      'template-insert:insert3g': => @replacer.insert(3,true)
      'template-insert:insert4g': => @replacer.insert(4,true)
      'template-insert:insert5g': => @replacer.insert(5,true)
      'template-insert:insert6g': => @replacer.insert(6,true)
      'template-insert:insert7g': => @replacer.insert(7,true)
      'template-insert:insert8g': => @replacer.insert(8,true)
      'template-insert:insert9g': => @replacer.insert(9,true)
      'template-insert:insert0g': => @replacer.insert(0,true)

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @templateInsertView.destroy()

  serialize: ->
    templateInsertViewState: @templateInsertView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor()
      if editor
        grammar = editor.getGrammar()
        @templateInsertView.setText(grammar.name, grammar.scopeName)
        @modalPanel.show()
