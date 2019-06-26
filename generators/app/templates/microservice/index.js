require('dotenv').config()
const { forEach } = require('lodash')
const { createServer } = require('http')
const { createQueueService } = require('@hindawi/queue-service')
const logger = require('@pubsweet/logger')

const PORT = process.env.PORT || 3000
const server = createServer((req, res) => {
  res.end('Service <%= serviceName%> is UP')
})

function registerEventHandlers(messageQueue) {
  const handlers = require('./src/eventHandlers')

  forEach(handlers, (handler, event) => messageQueue.registerEventHandler({ event, handler }))
}

(async function main() {
  const messageQueue = await createQueueService()

  registerEventHandlers(messageQueue)

  global.applicationEventBus = messageQueue

  messageQueue.start()

  server.listen(PORT, () => {
    logger.info(`Service <%= serviceName%> listening on port ${PORT}.`)
  })
}())
