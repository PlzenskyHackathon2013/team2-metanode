require 'colors'

require('cson-config').load()


hub = require('p2p-hub').connect(process.config.peer)

Federation = require('./lib/federation')
fed = new Federation hub


require('./lib/http').init fed


# federation = fed