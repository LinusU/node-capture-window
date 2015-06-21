var temp = require('fs-temp').template('%s.png')
var addon = require('./build/Release/capture-window')

module.exports = function captureWindow (bundle, title, filePath, cb) {
  var done = (typeof filePath === 'function' ? filePath : cb)
  var hasPath = (typeof filePath === 'string')

  function withPath (err, filePath) {
    if (err) return done(err)

    addon.captureWindow(bundle, title, filePath, done)
  }

  if (hasPath) {
    withPath(null, filePath)
  } else {
    temp.writeFile('', withPath)
  }
}
