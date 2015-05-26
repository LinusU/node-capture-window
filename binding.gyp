{
  "targets": [{
    "target_name": "capture-window",
    "sources": [ "src/capture-window.cc" ],
    "include_dirs" : [
      "<!(node -e \"require('nan')\")"
    ],
    "conditions": [
      ["OS==\"mac\"", {
        "libraries": [ "-framework Foundation" ],
        "xcode_settings": {
          "OTHER_CFLAGS": [ "-ObjC++" ]
        }
      }]
    ]
  }]
}
