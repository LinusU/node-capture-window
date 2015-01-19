
var child_process = require('child_process');
var addon = require('../build/Release/capture-window');


module.exports = function captureWindow_Apple(bundle, title, filePath, cb) {

  var bin = '/usr/sbin/screencapture';
  var windowId = addon.getWindowId(bundle, title);

  if (windowId === undefined) {
    return cb(new Error('Failed to find window'));
  }

  var args = [
    '-o',
    '-l' + windowId,
    filePath
  ];

  child_process.execFile(bin, args, function (err, stdout, stderr) {
    if (err) { return cb(err); }

    cb(null, filePath);
  });
};
