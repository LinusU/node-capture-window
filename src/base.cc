
class CaptureWindowWorker : public Nan::AsyncWorker {
public:
  CaptureWindowWorker (v8::Local<v8::Value> bundle, v8::Local<v8::Value> title, v8::Local<v8::Value> path, Nan::Callback *callback)
    : Nan::AsyncWorker(callback), bundle(bundle), title(title), path(path) {}
  ~CaptureWindowWorker () {}

  void Execute ();

  void HandleOKCallback () {
    v8::Local<v8::Value> argv[] = {
      Nan::Null(),
      Nan::New(*path).ToLocalChecked()
    };

    callback->Call(2, argv);
  }

private:
  Nan::Utf8String bundle;
  Nan::Utf8String title;
  Nan::Utf8String path;
};

NAN_METHOD(capture_window) {
  Nan::Callback *cb = new Nan::Callback(info[3].As<v8::Function>());
  Nan::AsyncQueueWorker(new CaptureWindowWorker(info[0], info[1], info[2], cb));
}

NAN_MODULE_INIT(Initialize) {
  Nan::Set(target, Nan::New("captureWindow").ToLocalChecked(),
    Nan::GetFunction(Nan::New<v8::FunctionTemplate>(capture_window)).ToLocalChecked());
}

NODE_MODULE(capture_window, Initialize)
