
var fs = require('fs');
var assert = require('assert');
var captureWindow = require('..');

describe('captureWindow', function () {

  var cleanup = [];

  afterEach(function () {
    cleanup.forEach(fs.unlinkSync.bind(fs));
    cleanup = [];
  });

  it('captures a window', function (done) {

    captureWindow('Window Server', 'Menubar', function (err, filePath) {

      assert.ifError(err);
      cleanup.push(filePath);

      fs.readFile(filePath, function (err, data) {

        assert.ifError(err);
        assert.equal(data[0], 0x89);
        assert.equal(data[1], 0x50);
        assert.equal(data[2], 0x4E);
        assert.equal(data[3], 0x47);
        assert.equal(data[4], 0x0D);
        assert.equal(data[5], 0x0A);
        assert.equal(data[6], 0x1A);
        assert.equal(data[7], 0x0A);

        done();

      });

    });

  });

});
