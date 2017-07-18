fs = require 'fs'
CSON = require 'season'
Config = require './config'
Replacer = require './replacer'
utils = require './utils'
readline = require 'readline'
remote = require('electron').remote
dialog = remote.dialog
$ = jQuery = require 'jquery'

module.exports =
class Structure
  constructor: () ->
    @conf = new Config
    @replacer = new Replacer

  create: (event,commands) ->
    for com in commands
      file = com.file
      break if com.command is event.type

    try
      rootPath = dialog.showOpenDialog({properties:['openDirectory'],title:"Select a root folder"})[0]
      rd = readline.createInterface(
        input: fs.createReadStream utils.getConfig("structureDirectory") + "/#{file}"
      )

      paths = []
      tempPath = "#{rootPath}/"
      prevLevel = 0
      level = 0
      count = 0
      tabsize = 0
      checked = false
      error = 0
      linecount = 0

      rd.on 'line', (line) ->
        if error is 0
          linecount = linecount + 1

          level = line.split(/[^ ]/)[0].length
          if level > 0 and !checked
            tabsize = level
            checked = true

          if level > 0
            level = level/tabsize

          if (level-prevLevel) > 1
            error = linecount

          tempOpt = line.trim().split(/(".*?"|\S+)/g)
          options = []

          for i in [0...tempOpt.length]
            if not (tempOpt[i] is "" or tempOpt[i] is " ")
              options.push(if tempOpt[i].match(/\".*\"/) then tempOpt[i].slice(1,-1) else tempOpt[i])

          line = options[0]
          paths.push({})

          if options.length > 1
            if options[1] is "d" then paths[count].type = "d"
            else
              paths[count].type = "f"
              paths[count].content = options[1]

          if options.length is 3 then paths[count].vars = options[2]

          if prevLevel is level
            tempPath = (tempPath.slice 0, tempPath.lastIndexOf('/')) + "/#{line}"
          else
            if prevLevel < level
              paths[count-1].leaf = false
              paths[count-1].type = "d"
            else
              tempPath = tempPath.slice 0, tempPath.lastIndexOf('/') for i in [-1...(prevLevel-level)]

            tempPath += "/#{line}"
            prevLevel = level

          paths[count].name = tempPath
          paths[count].type = "f" if options.length is 1
          paths[count].leaf = true
          count++

      self = this
      rd.on 'close', () ->
        if error is 0
          atom.project.addPath(rootPath)

          for p in paths
            if p.type is "f"
              file = fs.openSync(p.name, 'w')

              if p.hasOwnProperty('content')
                title = p.name.slice(p.name.lastIndexOf('/')+1)
                properties = {title: title, path: p.name}
                properties.vars = if p.hasOwnProperty('vars') then p.vars else ""
                fs.writeFileSync(p.name, self.replacer.replaceVariables(p.content,null,properties))

              fs.closeSync(file)
            else fs.mkdirSync(p.name)
        else
          utils.addError "Structure Failure", "A folder or a file has no parent directory", "Check your structure at line #{error}"
    catch e then console.log e
