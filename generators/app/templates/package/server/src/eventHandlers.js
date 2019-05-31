const models = require('@pubsweet/models')

const useCases = require('./use-cases')

module.exports = {
  async eventHandlerCodeHere(data) {
    return useCases.placeholderUseCase.initialize({ models }).execute(data)
  },
}
