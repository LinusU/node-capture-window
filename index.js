
var capture = require('./lib/capture');
var temp = require('fs-temp').template('%s.png');

module.exports = function captureWindow(bundle, title, filePath, cb) {

  var done = (typeof filePath === 'function' ? filePath : cb);
  var hasPath = (typeof filePath === 'string');

  function withPath(err, filePath) {
    if (err) { return done(err); }

    capture(bundle, title, filePath, done);
  }

  if (hasPath) {
    setImmediate(withPath, null, filePath);
  } else {
    temp.writeFile('', withPath);
  }

};
