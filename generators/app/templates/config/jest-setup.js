const { startsWith } = require('lodash')
const { configure } = require('react-testing-library')

const originalConsoleError = console.error
console.error = function newLog(msg) {
  if (startsWith(msg, 'Error: Could not parse CSS stylesheet')) return
  originalConsoleError(msg)
}

configure({
  testIdAttribute: 'data-test-id',
})
