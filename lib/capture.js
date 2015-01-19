
var os = require('os');

switch (os.platform()) {
  case 'darwin':
    module.exports = require('./apple');
    break;
  default:
    throw new Error('Platform not implemented');
}
