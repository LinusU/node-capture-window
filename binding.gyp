{
  "targets": [{
    "target_name": "capture-window",
    "sources": [ "src/capture-window.cc" ],
    "include_dirs" : [
      "<!@(node -p \"require('node-addon-api').include\")"
    ],
    "dependencies": [
      "<!(node -p \"require('node-addon-api').gyp\")"
    ],
    "cflags!": [ "-fno-exceptions" ],
    "cflags_cc!": [ "-fno-exceptions" ],
    "conditions": [
      ["OS==\"mac\"", {
        "libraries": [ "-framework Foundation" ],
        "cflags+": [ "-fvisibility=hidden" ],
        "xcode_settings": {
          "OTHER_CFLAGS": [ "-ObjC++" ],
          "GCC_ENABLE_CPP_EXCEPTIONS": "YES",
          "CLANG_CXX_LIBRARY": "libc++",
          "MACOSX_DEPLOYMENT_TARGET": "10.7",
          "GCC_SYMBOLS_PRIVATE_EXTERN": "YES"
        }
      }]
    ]
  }]
}
