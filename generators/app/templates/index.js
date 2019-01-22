const fs = require('fs')
const path = require('path')

const resolvers = require('./server/src/resolvers')

module.exports = {
  resolvers,
  typeDefs: fs.readFileSync(
    path.join(__dirname, '/server/src/typeDefs.graphqls'),
    'utf8',
  ),
}
