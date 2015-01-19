
# `capture-window`

Capture a desktop window to a png file. Simple and easy.

## Installation

```sh
npm install --save capture-window
```

## Usage

```javascript
var captureWindow = require('capture-window');

captureWindow('Finder', 'Downloads', function (err, filePath) {
  if (err) { throw err; }

  // filePath is the path to a png file
});
```

## API

### `captureWindow(bundle, title[, filePath], cb)`

Captures the window with the title `title` of type `bundle`. `bundle` is usually the name
of the application, e.g. `Finder`, `Safari`, `Terminal`.

The callback receives `(err, filePath)`.

## OS Support

Only `Mac OS X` at the time being. The source is well prepared for other
systems, pull requests welcome.

## License

MIT
