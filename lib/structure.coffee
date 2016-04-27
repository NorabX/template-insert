fs = require 'fs'
CSON = require 'season'
Config = require './config'
Replacer = require './replacer'
utils = require './utils'
readline = require 'readline'

module.exports =
class Structure
  constructor: () ->
    @conf = new Config
    @replacer = new Replacer

  create: (event,commands) ->
    for com in commands
      file = com.file
      break if com.command is event.type

    rootPath = event.currentTarget.getPath()
    if fs.lstatSync(rootPath).isDirectory()
      rd = readline.createInterface(
        input: fs.createReadStream utils.getConfig("structureDirectory") + "/#{file}"
      )

      paths = []
      tempPath = "#{rootPath}/"
      prevLevel = 0
      level = 0
      count = 0

      rd.on 'line', (line) ->
        level = line.split(/[^ ]/)[0].length
        tempOpt = line.trim().split(/('.*?'|".*?"|\S+)/g)
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
            console.log paths[count].content

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
    else utils.addError "Root Path Error", "Root Path #{rootPath} is not a Directory!"

  createStructure: (data) ->
    console.log data
