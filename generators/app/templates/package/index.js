const fs = require('fs')
const path = require('path')

const resolvers = require('./server/src/resolvers')
const eventHandlers = require('./server/src/eventHandlers')

module.exports = {
  resolvers,
  eventHandlers,
  typeDefs: fs.readFileSync(
    path.join(__dirname, '/server/src/typeDefs.graphqls'),
    'utf8',
  ),
}
