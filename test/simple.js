/* eslint-env mocha */

const fs = require('fs')
const assert = require('assert')
const captureWindow = require('../')

describe('captureWindow', function () {
  let cleanup = []

  afterEach(async () => {
    for (const item of cleanup) fs.unlinkSync(item)
    cleanup = []
  })

  it('captures a window', async () => {
    const filePath = await captureWindow('Window Server', 'Menubar')
    cleanup.push(filePath)

    const data = fs.readFileSync(filePath)

    assert.equal(data[0], 0x89)
    assert.equal(data[1], 0x50)
    assert.equal(data[2], 0x4E)
    assert.equal(data[3], 0x47)
    assert.equal(data[4], 0x0D)
    assert.equal(data[5], 0x0A)
    assert.equal(data[6], 0x1A)
    assert.equal(data[7], 0x0A)
  })
})
