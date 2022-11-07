{
  "targets": [{
    "target_name": "capture_window",
    "sources": [ "src/capture-window.c" ],
    "conditions": [
      ["OS==\"mac\"", {
        "libraries": [ "-framework Cocoa", "-framework CoreGraphics" ],
        "xcode_settings": {
          "OTHER_CFLAGS": [ "-ObjC" ]
        }
      }]
    ]
  }]
}
