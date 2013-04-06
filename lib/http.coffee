debug = require('debug') 'http'
colors = require 'colors'
express = require 'express'
http = require 'http'

app = express()




http = require('http')
server = http.createServer(app)
io = require('socket.io').listen(server);

io.set 'log level', 0

exports.init = (federation) ->	
	app.use express.static 'public'


	app.get '/', (req, res) ->
		res.json
			welcome: '.meta'
			hosts: federation.getNodes()
	
	io.sockets.on 'connection', (socket) ->
		socket.on 'create-channel', (data) ->
			federation.createChannel data, (err, data) ->
				socket.emit 'channel-created', err or data
				

		socket.on 'publish', (data) ->
			federation.publish data, (err, data) ->
				socket.emit 'published', err or data

		socket.on 'search', (data) ->
			# console.log arguments
			search = federation.search data
			search.on 'data', (data) ->
				socket.emit 'search-result', data
	  

	port = process.config.port 
	server.listen port
	debug "web on #{port}"

