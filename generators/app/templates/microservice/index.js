const { forEach } = require('lodash')
require('./node_modules/dotenv').config() // eslint-disable-line

const { createQueueService } = require('./node_modules/component-queue-service') // eslint-disable-line

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
