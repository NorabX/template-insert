module.exports = Utils =
  getConfig: (name) ->
    atom.config.get("template-insert.#{name}")

  addError: (title,msg,details) ->
    atom.notifications.addError "<h2>#{title}</h2>#{msg}" , {detail: details}
