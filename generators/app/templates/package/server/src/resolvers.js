const models = require('@pubsweet/models')

const useCases = require('./use-cases')

const resolvers = {
  Query: {},
  Mutation: {
    async mutationCodeHere(_, params, ctx) {
      return useCases.placeholderUseCase.initialize({ models }).execute(params)
    },
  },
}

module.exports = resolvers
