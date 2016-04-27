module.exports = Utils =
  getConfig: (name) ->
    atom.config.get("template-insert.#{name}")

  addError: (title,msg) ->
    atom.notifications.addError "<h2>#{title}</h2>#{msg}"
