require 'colors'

require('cson-config').load()


hub = require('p2p-hub').connect("192.168.2.6")

Federation = require('./lib/federation')
fed = new Federation hub


require('./lib/http').init fed


# federation = fed