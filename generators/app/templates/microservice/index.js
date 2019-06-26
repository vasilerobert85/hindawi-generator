const { forEach } = require('lodash')
require('dotenv').config()

const { createQueueService } = require('@hindawi/queue-service')

function registerEventHandlers(messageQueue) {
  const handlers = require('./src/eventHandlers')

  forEach(handlers, (handler, event) => messageQueue.registerEventHandler({ event, handler }))
}

(async function main() {
  const messageQueue = await createQueueService()

  registerEventHandlers(messageQueue)

  global.applicationEventBus = messageQueue

  messageQueue.start()
}())
