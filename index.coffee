require 'colors'

require('cson-config').load()

unless process.config.port
	console.log "Missing PORT".red

	return

hub = require('p2p-hub').connect()

Federation = require('./lib/federation')
fed = new Federation hub


require('./lib/http').init fed


# federation = fed