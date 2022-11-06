# `capture-window`

Capture a desktop window to a png file. Simple and easy.

## Installation

```sh
npm install --save capture-window
```

## Usage

```javascript
const captureWindow = require('capture-window')

captureWindow('Finder', 'Downloads').then((filePath) => {
  // filePath is the path to a png file
})
```

## API

### `captureWindow(bundle, title[, filePath])`

- `bundle` (`string`, required)
- `title` (`string`, required)
- `filePath` (`string | null`, optional)
- returns `Promise<string>` - path to a png file

Captures the window with the title `title` of type `bundle`. `bundle` is usually the name of the application, e.g. `Finder`, `Safari`, `Terminal`.

## OS Support

Only `Mac OS X` at the time being. The source is well prepared for other systems, pull requests welcome.

## License

MIT
