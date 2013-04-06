debug = require('debug') 'federation'
crypto = require 'crypto'
async = require 'async'
EventEmitter = require('events').EventEmitter
randname = require './randname'
store = require './store'
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

			if message
				type = message.type 
				data = message.data
				if type is 'search'
					console.log '>>>>>>>>'.yellow
					console.log message
					@localSearch message, done
				if type is 'create-channel'
					console.log data
					store.createChannel data, done

				if type is 'find-channel'
					console.log data
					store.findChannel data, done


				if type is 'publish'
					store.publishToChannel data, message.channel, done

				

	createChannel: (data, done) ->
		@fed.send @getRandomNode(), {type: 'create-channel', data: data}, done
			
			
	publish: (data, done) ->
		# @fed.send @getRandomNode(), {type: 'create-channel', data: data}, done
		
		found = no

		async.forEach @getAllNodes(), (node, next) =>
			@fed.send node, {type: 'find-channel', data: data.channel}, (err, channel) =>
				if channel?.uuid
					found = yes
					@fed.send node, {type: 'publish', data: data, channel: channel}, done
					
				next()
		, (err) ->
			done "Channel not found" unless found
			

		

	localSearch: (query, done) ->
		done null, "search resultxxxx from #{@name}: " + JSON.stringify query

	getRandomNode: () ->
		n = @getAllNodes()
		n[Math.floor(Math.random() * n.length)]

	getAllNodes: () ->
		n = @hub.nodes()
		n.push @hub.address
		console.log n
		n
	
	search: (query, done) ->
		# hash = md5 JSON.stringify query
		em = new EventEmitter 
		# jinak se to neemittne
		process.nextTick () =>
			async.forEach @getAllNodes(), (node, next) =>
				# console.log node
				@fed.send node, {type: 'search', data: query}, (err, data) ->
					## todo handle error
					em.emit 'data', data 

				next()

			
		return em
