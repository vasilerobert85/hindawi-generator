const useCases = require('./use-cases')

module.exports = {
  async PlaceHolderEventHandler(data) {
    return useCases.placeholderUseCase.initialize().execute(data)
  },
}
