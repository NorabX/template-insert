module.exports =
class Config
  constructor: () ->
    @defaultTemplateFolder = atom.packages.resolvePackagePath('template-insert') + '/templates'
    @initDate = new Date(1234567891011)
    @dateArray = @getDateArray(@initDate)

  getDateArray: (date) ->
    [
      date.toLocaleString()
      date.toLocaleDateString()
      date.toLocaleTimeString()
      date.toDateString()
      date.toTimeString()
      date.toUTCString()
      date.toISOString()
    ]

  getDate: (date) ->
    n = 0
    for d in @dateArray
      if d is date then return @getDateArray(new Date())[n]
      n++

  get: ->
    templateDirectory:
      type: 'string'
      description: 'Directory that contains all template files'
      default: @defaultTemplateFolder
      order: 10
    customVariablesFile:
      type: 'string'
      description: 'File that contains all custom variables'
      default: @defaultTemplateFolder + "/vars.cson"
      order: 20
    author:
      type: 'string'
      description: 'Text for }a{ variable'
      default: 'Author'
      order: 30
    dateStringOne:
      type: 'string'
      description: 'Date string for }d{'
      default: @initDate.toLocaleString()
      enum: @dateArray
      order: 40
    dateStringTwo:
      type: 'string'
      description: 'Date string for }D{'
      default: @initDate.toISOString()
      enum: @dateArray
      order: 50
    globalNumberVariables:
      type: 'string'
      description: 'Set global variables }0g{, }1g{, ...'
      default: ''
      order: 60
    localVariableDelimiter:
      type: 'string'
      default: ';'
      order: 70
    globalVariableDelimiter:
      type: 'string'
      default: ';'
      order: 80
    showTemplateError:
      type: 'boolean'
      description: 'Shows an error when a template is missing'
      default: true
      order: 90
    recursionVariableLevels:
      type: 'integer'
      min: 0
      max: 100
      default: 1
      order: 100
    recursionPathLevels:
      type: 'integer'
      min: 0
      max: 100
      default: 1
      order: 110
