hub = require('p2p-hub').connect('192.168.2.6')


app = hub.multiplex('app');

app.on 'connect', (from) ->
    console.log(from, 'connected to app')
    console.log('all in app:', app.nodes())

app.on 'disconnect', (from) ->
    console.log(from, 'disconnected from app')

app.on 'message', (from, message) ->
    console.log(from, 'in app says', message)
	
app.send('json://another_member', {hello:'app'})
console.log 'xx'