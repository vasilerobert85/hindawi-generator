const logger = require('@pubsweet/logger')
const models = require('component-model')
const { services } = require('helper-service')
const { withAuthsomeMiddleware } = require('helper-service')

const useCases = require('./use-cases')

const resolvers = {
  Query: {},
  Mutation: {
    async mutationCodeHere(_, { input }, ctx) {
      return useCases.placeholderUseCase
        .initialize({ logger, models, services })
        .execute(input)
    },
  },
}

module.exports = withAuthsomeMiddleware(resolvers, useCases)
