debug = require('debug') 'federation'
crypto = require 'crypto'
async = require 'async'
EventEmitter = require('events').EventEmitter
randname = require './randname'

md5 = (s) ->
	crypto.createHash('md5').update(s).digest('hex')

module.exports = class Federation 

	constructor: (@hub) ->
		@name = randname.get()
		debug "NAME --- " + @name.red
		@fed = @hub.multiplex('federation')

		@fed.on 'connect', (from) =>
		    debug from + ' connected to app'.green
		    debug "nodes" , @hub.nodes()

		@fed.on 'disconnect', (from) =>
		    debug from + ' disconnected from app'.red
		    debug "nodes" , @hub.nodes()

		@fed.on 'message', (from, message, done) =>
			if message?.type is 'search'
				console.log '>>>>>>>>'.yellow
				console.log message
				@localSearch message, done


	localSearch: (query, done) ->
		done null, "search result from #{@name}: " + JSON.stringify query

	getNodes: () ->
		@hub.nodes()
	
	search: (query, done) ->
		console.log query.red
		hash = md5 JSON.stringify query
		
		em = new EventEmitter 
		
		## poslu search request na ostatni nody
		async.forEach @hub.nodes(), (node, next) =>
			# console.log node
			@fed.send node, {type: 'search', data: query}, (err, data) ->
				## todo handle error
				em.emit 'data', data 

			next()

		## poslu search na lokalni server
		process.nextTick () =>
			@localSearch data: query, (err, data) ->
				## todo handle error
				em.emit 'data', data 
			
		return em
