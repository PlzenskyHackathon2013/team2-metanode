debug = require('debug') 'store'
mongoq = require 'mongoq'
uuid = require 'node-uuid'


m = mongoq process.config.mongo

exports.createChannel = (data, done) ->
	debug "creating channel #{data.name}"
	
	hash = uuid.v4()
	data.uuid = hash
	m.collection('channels').insert data, (err, result) ->
		# console.log arguments
		done err, result?[0]
		
	
exports.findChannel = (uuid, done) ->
	debug "looking up channel #{uuid}"
	m.collection('channels').find(uuid: uuid).toArray (err, result) ->
		# console.log arguments
		done err, result?[0]


exports.publishToChannel = (data, channel, done) ->
	debug "publishing #{data.uri} to #{channel.name}"
	
	m.collection("channel_#{channel_type}").find(uri: data.uri).toArray (err, result) ->
		return done err if err

		channelData = result?[0]
		unless channelData 
			channelData = 
				uri: data.uri
				channel: channel.uuid
			channelData["#{channel_type}"] = []
				
		console.log channelData 
				
		
			
		
		# console.log arguments
		done err, result?[0]
		


