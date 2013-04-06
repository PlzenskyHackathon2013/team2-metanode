hub = require('p2p-hub').connect("json://10.10.10.58")

fed = hub.multiplex('federation')

fed.on 'connect', (from) =>
    debug from + ' connected to app'.green
    debug "nodes" , @hub.nodes()
