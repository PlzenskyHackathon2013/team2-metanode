hub = require('p2p-hub').connect()

fed = hub.multiplex('federation')

fed.on 'connect', (from) =>
    debug from + ' connected to app'.green
    debug "nodes" , @hub.nodes()
