debug = require('debug') 'http'
colors = require 'colors'
express = require 'express'
http = require 'http'

app = express()




http = require('http')
server = http.createServer(app)
io = require('socket.io').listen(server);

exports.init = (federation) ->	
	app.use express.static 'public'


	app.get '/', (req, res) ->
		res.json
			welcome: '.meta'
			hosts: federation.getNodes()

	app.get '/search/:query', (req, res, next) ->
		federation.search req.params.query, (err, data) ->
			return next err if err
			
			res.json data

	
	io.sockets.on 'connection', (socket) ->
	  socket.emit 'news', hello: 'world'

	  socket.on 'plus', (data) ->
		  console.log "#{data}".red
		  socket.emit 'result', ++data
	  


	port = process.config.port 
	server.listen port
	debug "web on #{port}"

