const temp = require('fs-temp/promise').template('%s.png')
const addon = require('./build/Release/capture_window')

module.exports = async function captureWindow (bundle, title, filePath) {
  if (filePath == null) filePath = await temp.writeFile('')

  return addon.capture(bundle, title, filePath)
}
