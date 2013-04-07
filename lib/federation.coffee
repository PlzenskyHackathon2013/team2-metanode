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
		@registeredSearches = {}
		
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
					# console.log '>>>>>>>>'.yellow
					# console.log message
					#@localSearch message, done
					store.findAllForUri data, done
					#done null, "search resultxxxx from #{@name}: " + JSON.stringify query
					
					
				else if type is 'create-channel'
					# console.log data
					store.createChannel data, done

				else if type is 'find-channel'
					# console.log data
					store.findChannel data, done


				else if type is 'find-all-channels'
					store.findAllChannels done


				else if type is 'notify-update'
					for item in data
						# console.log 'uuuuuuuuuuu'
						# console.log item
						# console.log @registeredSearches
						# store.findChannel data, done
						if @registeredSearches[item.uri]
							# console.log 'asd9adia9sdia9dias90dias90dia90sdi0d9iasd90aid90sd'
							for key,rs of @registeredSearches[item.uri]
								## TODO kdyz nema listenery, zabit
								# console.log 'rrrrrrrrrr'.blue
								item.hash = rs.hash
								rs.emit 'data', [item]
					

				else if type is 'publish'
					store.publishToChannel data, message.channel, (err, data) =>
						@notifyUpdate data unless err
						
						done err, data

				
	notifyUpdate: (data) ->
		for node in @getAllNodes()
			@fed.send node, {type: 'notify-update', data: data}, () ->

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
			

		


	getRandomNode: () ->
		n = @getAllNodes()
		n[Math.floor(Math.random() * n.length)]

	getAllNodes: () ->
		n = @hub.nodes()
		n.push @hub.address
		# console.log n
		n
	unsearch: (data, done) ->
		data.hash
		delete @registeredSearches[query][data.emhash]
		
	
	search: (data, done) ->
		query = data.uri
		
		@registeredSearches[query] ?= {}
		em = new EventEmitter 
		
		# TODO uklizet
		@registeredSearches[query][data.emhash] = em
		
		hash = data.hash 
		em.hash = hash
		
		# jinak se to neemittne
		process.nextTick () =>
			async.forEach @getAllNodes(), (node, next) =>
				# console.log node
				@fed.send node, {type: 'search', data: query}, (err, data) ->
					## todo handle error
					return if data?.length is 0
					for item in data
						item.hash = hash

					em.emit 'data', data 

				next()

			
		return em


	findChannels: (done) ->
		em = new EventEmitter 

		# jinak se to neemittne
		process.nextTick () =>
			async.forEach @getAllNodes(), (node, next) =>
				# console.log node
				@fed.send node, {type: 'find-all-channels'}, (err, data) ->
					# console.log arguments
					## todo handle error
					return if data?.length is 0

					em.emit 'data', data 

				next()

			
		return em
