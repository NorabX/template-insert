GrammarView = require './views/grammar-view'
Config = require './config'
Replacer = require './replacer'
Structure = require './structure'

utils = require './utils'
fs = require 'fs'

{CompositeDisposable} = require 'atom'

module.exports = TemplateInsert =
  grammarView: null
  modalPanel: null
  subscriptions: null
  config: new Config().get()
  replacer: null
  structure: null

  activate: (state) ->
    @grammarView = new GrammarView(state.grammarViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @grammarView.getElement(), visible: false)
    @replacer = new Replacer
    @structure = new Structure
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


    atom.packages.onDidActivateInitialPackages () ->
      TemplateInsert.createTreeContextMenu()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @grammarView.destroy()

  serialize: ->
    grammarViewState: @grammarView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor()
      if editor
        grammar = editor.getGrammar()
        @grammarView.setText(grammar.name, grammar.scopeName)
        @modalPanel.show()

  createTreeContextMenu: () ->
    exts = [".atps",".atoemps"]
    regex = new RegExp ".*(#{exts[0]}|#{exts[1]})"
    strcDir = utils.getConfig 'structureDirectory'
    strcMenus = []
    strcFiles = []

    fs.readdir strcDir, (err, tempFiles) ->
      showError = utils.getConfig 'template-insert.showStructureDirectoryError'
      if err then if showError then utils.addError "Structure Directory Error", "Directory #{strcDir} doesn't exist"
      else
        for file in tempFiles
          if file.match(regex)
            filename = file.substring 0, file.lastIndexOf(exts[if file.lastIndexOf(exts[0]) > -1 then 0 else 1])
            com = "template-insert:create-structure-#{file}"

            TemplateInsert.subscriptions.add atom.commands.add '.tree-view .selected',
              com, (event) => TemplateInsert.structure.create(event,strcFiles)

            strcFiles.push({file: file, command: com})
            strcMenus.push({label: filename, command: com})

      if strcMenus.length > 0
        atom.contextMenu.add {
            '.tree-view .selected':
              [{
                label: 'Create Structure',
                submenu: strcMenus
              }]
        }
