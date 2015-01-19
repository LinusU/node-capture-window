{
  "targets": [{
    "target_name": "capture-window",
    "sources": [ "src/capture-window.cc" ],
    "include_dirs" : [
      "<!(node -e \"require('nan')\")"
    ],
    "conditions": [
      ["OS==\"mac\"", {
        "xcode_settings": {
          "OTHER_CFLAGS": [ "-ObjC++" ]
        }
      }]
    ]
  }]
}
