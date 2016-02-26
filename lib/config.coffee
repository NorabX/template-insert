module.exports =
class Config
  constructor: () ->
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
      default: atom.packages.resolvePackagePath('template-insert') + '/templates'
      order: 0
    author:
      type: 'string'
      description: 'Text for }a{ variable'
      default: 'Author'
      order: 1
    dateStringOne:
      type: 'string'
      description: 'Date string for }d{'
      default: @initDate.toLocaleString()
      enum: @dateArray
      order: 2
    dateStringTwo:
      type: 'string'
      description: 'Date string for }D{'
      default: @initDate.toISOString()
      enum: @dateArray
      order: 3
    globalNumberVariables:
      type: 'string'
      description: 'Set global variables }0g{, }1g{, ...'
      default: ''
      order: 4
    localVariableDelimiter:
      type: 'string'
      default: ';'
      order: 5
    globalVariableDelimiter:
      type: 'string'
      default: ';'
      order: 6
    showTemplateError:
      type: 'boolean'
      description: 'Shows an error when a template is missing'
      default: true
      order: 7
