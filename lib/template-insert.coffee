fs = require('fs')
os = require('os')
CSON = require 'season'
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

    @subscriptions.add atom.commands.add 'atom-workspace',
      'template-insert:toggle': => @toggle()
      'template-insert:insert1': => @insert(1,false)
      'template-insert:insert2': => @insert(2,false)
      'template-insert:insert3': => @insert(3,false)
      'template-insert:insert4': => @insert(4,false)
      'template-insert:insert5': => @insert(5,false)
      'template-insert:insert6': => @insert(6,false)
      'template-insert:insert7': => @insert(7,false)
      'template-insert:insert8': => @insert(8,false)
      'template-insert:insert9': => @insert(9,false)
      'template-insert:insert0': => @insert(0,false)
      'template-insert:insert1g': => @insert(1,true)
      'template-insert:insert2g': => @insert(2,true)
      'template-insert:insert3g': => @insert(3,true)
      'template-insert:insert4g': => @insert(4,true)
      'template-insert:insert5g': => @insert(5,true)
      'template-insert:insert6g': => @insert(6,true)
      'template-insert:insert7g': => @insert(7,true)
      'template-insert:insert8g': => @insert(8,true)
      'template-insert:insert9g': => @insert(9,true)
      'template-insert:insert0g': => @insert(0,true)

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

    @test()

  test: ->


  replaceVariables: (data) ->
    editor = atom.workspace.getActiveTextEditor()
    if editor
      title = editor.getTitle()

      reclevels = 0
      while true
        data = @replacePaths data

        data = @replaceNumberVariables(editor.getSelectedText(), data, false)
        data = @replaceNumberVariables(@getConfig('globalNumberVariables'), data, true)
        data = @replaceCustomVariables(data, editor.getGrammar().scopeName)

        data = data.replace /}f{/g, title.substring 0, title.lastIndexOf '.'
        data = data.replace /}F{/g, title
        data = data.replace /}p{/g, editor.getPath()
        data = data.replace /}a{/g, @getConfig 'author'
        data = data.replace /}d{/g, @conf.getDate @getConfig 'dateStringOne'
        data = data.replace /}D{/g, @conf.getDate @getConfig 'dateStringTwo'
        data = data.replace /}oa{/g, os.arch()
        data = data.replace /}oh{/g, os.homedir()
        data = data.replace /}oH{/g, os.hostname()
        data = data.replace /}op{/g, os.platform()
        data = data.replace /}or{/g, os.release()
        data = data.replace /}on{/g, os.type()
        data = data.replace /}ot{/g, os.tmpdir()

        data = @replacePaths data

        break if reclevels >= @getConfig('recursionVariableLevels')
        reclevels++

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

  replaceCustomVariables: (data, scopeName) ->
    if fs.existsSync @getConfig('customVariablesFile')
      try
        customvars = CSON.readFileSync(@getConfig('customVariablesFile'))

        if customvars?
          for scope in Object.keys(customvars)
            for key in Object.keys(customvars[scope])
              regex = new RegExp "}=#{key}{", 'g'
              if scope is 'global' or scope is scopeName
                data = data.replace regex, customvars[scope][key]

      catch err then atom.notifications.addError "<h2>Custom Variables File Syntax Error</h2>#{err}"

    data

  replacePaths: (data) ->
    tempPath = ""
    reclevels = 0

    while true
      start = data.search /}!/g
      break if start is -1

      end = data.search /!{/g
      path = data.slice start + 2, end
      regex = new RegExp "}!#{path}!{", 'g'

      if tempPath is path then reclevels++
      else tempPath = path

      if reclevels <= @getConfig('recursionPathLevels')
        if fs.existsSync path
          data = data.replace regex, fs.readFileSync path
        else
          data = data.replace regex, "}?#{path}?{"
      else
        reclevels = 0
        data = data.replace regex, "}#{path}{"

    data

  getConfig: (name) ->
    atom.config.get("template-insert.#{name}")
