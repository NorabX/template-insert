fs = require 'fs'
os = require 'os'
cproc = require 'child_process'
crypto = require 'crypto'
CSON = require 'season'
Config = require './config'

module.exports =
class Replacer
  constructor: () ->
    @conf = new Config()

  insert: (n, global) ->
    tempDir = @getConfig 'templateDirectory'
    self = this

    fs.exists tempDir, (exists) ->
      if exists
        showError = atom.config.get 'template-insert.showTemplateError'
        editor = atom.workspace.getActiveTextEditor()
        if editor
          scope = if global then 'global' else editor.getGrammar().scopeName
          file = "#{tempDir}/#{scope}.#{n}"

          fs.readFile file, 'utf8', (err, data) ->
            if err
              file = "#{tempDir}/#{scope}.#{n}.atoemp"
              fs.readFile file, 'utf8', (err, data) ->
                if err and showError then self.addError "Template is missing", "Add #{file}"
                else self.insertData editor, data
            else self.insertData editor, data
      else @self.addError "Template Directory Error", "Directory #{tempDir} doesn't exist"

  replaceVariables: (data) ->
    editor = atom.workspace.getActiveTextEditor()
    if editor

      reclevels = 0
      while true
        #data = @replacePaths data

        data = @replaceNumberVariables editor.getSelectedText(), data, false
        data = @replaceNumberVariables @getConfig('globalNumberVariables'), data, true
        data = @replaceCustomVariables data, editor.getGrammar().scopeName
        data = @replaceStandardVariables data, editor
        data = @replaceOSVariables data
        data = @replaceHashVariables data
        data = @replaceCommandVariables data

        data = @replacePaths data

        break if reclevels >= @getConfig('recursionVariableLevels')
        reclevels++

      data

  replaceNumberVariables: (text, data, global) ->
    if text isnt '' and text?
      delimiter = if global then @getConfig('globalVariableDelimiter') else @getConfig('localVariableDelimiter')
      split = text.split delimiter
      for n in [0..split.length-1]
        temp = if global then 'g' else ''
        regex = new RegExp "}#{n}#{temp}{", 'g'
        data = data.replace regex, split[n]

    data

  replaceStandardVariables: (data, editor) ->
    title = editor.getTitle()
    data = data.replace /}f{/g, @replaceFilenameWithoutExtension title
    data = data.replace /}F{/g, title
    data = data.replace /}p{/g, editor.getPath()
    data = data.replace /}a{/g, @getConfig 'author'
    data = data.replace /}d{/g, @conf.getDate @getConfig 'dateStringOne'
    data = data.replace /}D{/g, @conf.getDate @getConfig 'dateStringTwo'

    data = data.replace /}td{/g, @getConfig('templateDirectory') + "/"
    data = data.replace /}v{/g, @replaceVarFileName @getConfig('customVariablesFile')
    data = data.replace /}V{/g, @getConfig('customVariablesFile')
    data = data.replace /}vd{/g, @replaceVarFileDir @getConfig('customVariablesFile')
    data

  replaceFilenameWithoutExtension: (title) ->
    if title.indexOf('.') isnt -1
      title.substring 0, title.lastIndexOf '.'
    else title

  replaceVarFileName: (path) ->
    path.substring path.lastIndexOf '/'

  replaceVarFileDir: (path) ->
    path.substring 0, path.lastIndexOf '/'

  replaceOSVariables: (data) ->
    data = data.replace /}oa{/g, os.arch()
    data = data.replace /}oh{/g, os.homedir()
    data = data.replace /}oH{/g, os.hostname()
    data = data.replace /}op{/g, os.platform()
    data = data.replace /}or{/g, os.release()
    data = data.replace /}on{/g, os.type()
    data = data.replace /}ot{/g, os.tmpdir()

    data

  replaceHashVariables: (data) ->
    for hash in crypto.getHashes()
      if hash
        regex = new RegExp "}#{hash}=.*=(bytes|binary|hex|base64){", 'g'
        match = data.match(regex)
        if match
          for m in match
            value = m.slice m.indexOf("}#{hash}=") + 2 + hash.length, m.lastIndexOf '='
            digest = m.slice m.lastIndexOf('=') + 1, m.length - 1
            regex2 = new RegExp "}#{hash}=#{value}=#{digest}{", 'g'

            digest = if digest is 'bytes' then '' else digest
            replace = crypto.createHash(hash).update(value).digest(digest)

            if digest is ''
              temp = ''
              for b in replace
                temp += "#{b} "
              replace = temp

            data = data.replace regex2, replace

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

      catch err then @addError "Custom Variables File Syntax Error", "#{err}"

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

  replaceCommandVariables: (data) ->
    while true
      start = data.search /}>/g
      break if start is -1

      end = data.search /<{/g
      command = data.slice start + 2, end

      try
        child = cproc.execSync command
        child = child.slice 0, -1
      catch error then child = []

      commandreg = command.replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"
      regex = new RegExp "}>#{commandreg}<{", "g"

      if child.length > 0
        data = data.replace regex, child.toString()
      else
        data = data.replace regex, "}?#{command}?{"

    data

  getConfig: (name) ->
    atom.config.get("template-insert.#{name}")

  insertData: (editor,data) ->
    editor.insertText @replaceVariables data

  addError: (title,msg) ->
    atom.notifications.addError "<h2>#{title}</h2>#{msg}"
