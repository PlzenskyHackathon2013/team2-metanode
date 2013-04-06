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
		

exports.findAllChannels = (done) ->
	m.collection('channels').find().toArray done #(err, result) ->

exports.findAllForUri = (uri, done) ->
	# debug "looking up channel #{uuid}"
	m.collection('channel_data').find(uri: uri ).toArray done #(err, result) ->
		# console.log arguments
#		done err, result?[0]

	
exports.findChannel = (uuid, done) ->
	debug "looking up channel #{uuid}"
	m.collection('channels').find(uuid: uuid).toArray (err, result) ->
		# console.log arguments
		done err, result?[0]


exports.publishToChannel = (data, channel, done) ->
	debug "publishing #{data.uri} to #{channel.name}"
	o = 
		uri: data.uri
		channel: channel.uuid
		message: data.message
		date: new Date

	m.collection("channel_data").insert o, done #(err, result) ->
	
		# done err, result?[0]
		


