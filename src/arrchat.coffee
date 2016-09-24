cli = require 'commander'
cli.version '<%= version %>'

fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
colors = require 'colors'
ejs = require 'ejs'

global.mkdir = (dest) ->
  mkdirp.sync (path.dirname path.normalize dest), parseInt '0777', 8

global.copy = (src, dest) ->
  dest = path.normalize dest
  mkdir dest
  read = fs.createReadStream src
  read.pipe fs.createWriteStream dest
  read.on 'end', ->
    console.log 'created '.green + dest

global.copyTpl = (src, dest, data) ->
  src = path.normalize __dirname + '/../templates/' + src
  dest = path.normalize dest
  mkdir dest
  escape = (s) ->
    s = s.replace /__%/g, '<' + '%'
    s = s.replace /%__/g, '%' + '>'
    s
  fs.readFile src, (err, content) ->
    throw err if err?
    content = content.toString()
    fs.writeFile dest, (ejs.render content, data, escape: escape), (err) ->
      throw err if err?
      console.log 'created '.green + dest

<% commands.forEach(function(command) { %>
cli.command '<%= command.name %>'
  .description '<%= command.description %>'
  .action <%= command.action %>
<% }) %>

cli.parse process.argv

cli.outputHelp() if !process.argv.slice(2).length