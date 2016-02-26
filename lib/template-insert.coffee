fs = require('fs');
TemplateInsertView = require './template-insert-view'
Config = require './config'
{CompositeDisposable} = require 'atom'

module.exports = TemplateInsert =
  templateInsertView: null
  modalPanel: null
  subscriptions: null
  config: new Config().get()
  conf: null

  activate: (state) ->
    @templateInsertView = new TemplateInsertView(state.templateInsertViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @templateInsertView.getElement(), visible: false)
    @conf = new Config()
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert1': => @insert(1,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert2': => @insert(2,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert3': => @insert(3,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert4': => @insert(4,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert5': => @insert(5,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert6': => @insert(6,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert7': => @insert(7,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert8': => @insert(8,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert9': => @insert(9,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert0': => @insert(0,false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert1g': => @insert(1,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert2g': => @insert(2,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert3g': => @insert(3,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert4g': => @insert(4,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert5g': => @insert(5,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert6g': => @insert(6,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert7g': => @insert(7,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert8g': => @insert(8,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert9g': => @insert(9,true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'template-insert:insert0g': => @insert(0,true)

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

  insert: (n, global) ->
    tempDir = @getConfig 'templateDirectory'

    fs.exists tempDir, (exists) ->
      if exists
        showError = atom.config.get 'template-insert.showTemplateError'
        editor = atom.workspace.getActiveTextEditor()
        if editor
          scope = if global then 'global' else editor.getGrammar().scopeName
          file = "#{tempDir}/#{scope}.#{n}"

          fs.readFile file, 'utf8', (err, data) ->
            if err then if showError then atom.notifications.addError "<h2>Template is missing</h2>Add #{file}"
            else editor.insertText TemplateInsert.replaceVariables data

      else atom.notifications.addError "<h2>Template Directory Error</h2>Directory #{tempDir} doesn't exist"

  replaceVariables:(data) ->
    editor = atom.workspace.getActiveTextEditor()
    if editor
      title = editor.getTitle()
      date = new Date()
      data = data.replace /}f{/g, title.substring 0, title.lastIndexOf '.'
      data = data.replace /}F{/g, title
      data = data.replace /}p{/g, editor.getPath()
      data = data.replace /}a{/g, @getConfig 'author'
      data = data.replace /}d{/g, @conf.getDate @getConfig 'dateStringOne'
      data = data.replace /}D{/g, @conf.getDate @getConfig 'dateStringTwo'

      data = @replaceNumberVariables(editor.getSelectedText(), data, false)
      data = @replaceNumberVariables(@getConfig('globalNumberVariables'), data, true)

      data

  replaceNumberVariables: (text, data,  global) ->
    if text isnt '' and text?
      delimiter = if global then @getConfig('globalVariableDelimiter') else @getConfig('localVariableDelimiter')
      split = text.split delimiter
      for n in [0..split.length-1]
        temp = if global then 'g' else ''
        regex = new RegExp "}#{n}#{temp}{", 'g'
        data = data.replace regex, split[n]

    data

  getConfig: (name) ->
    atom.config.get("template-insert.#{name}")
