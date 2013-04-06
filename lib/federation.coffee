debug = require('debug') 'federation'
crypto = require 'crypto'
# async = require 'async'

md5 = (s) ->
	crypto.createHash('md5').update(s).digest('hex')

module.exports = class Fedaration 

	constructor: (@hub) ->
		@fed = @hub.multiplex('federation')

		@fed.on 'connect', (from) =>
		    debug from + ' connected to app'.green
		    debug "nodes" , @hub.nodes()

		@fed.on 'disconnect', (from) =>
		    debug from + ' disconnected from app'.red
		    debug "nodes" , @hub.nodes()

		@fed.on 'message', (from, message) =>
		    console.log from, 'in app says'.cyan, message


	debug 'connected to app'


	getNodes: () ->
		@hub.nodes()
	
	search: (query, done) ->
		hash = md5 JSON.stringify query

		for node in @hub.nodes()
			@fed.send node, {search: query}
			
		done()	
		


	# app.send('json://another_member', {hello:'app'});