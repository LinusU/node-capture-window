
#include <node.h>
#include <nan.h>

#ifdef __APPLE__
#include "apple.m"
#else
#error Platform not supported
#endif

void Initialize(v8::Handle<v8::Object> exports) {
  exports->Set(NanNew("getWindowId"), NanNew<v8::FunctionTemplate>(get_window_id)->GetFunction());
}

NODE_MODULE(capture_window, Initialize)
