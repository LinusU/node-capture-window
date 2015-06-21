
class CaptureWindowWorker : public NanAsyncWorker {
public:
  CaptureWindowWorker (v8::Local<v8::Value> bundle, v8::Local<v8::Value> title, v8::Local<v8::Value> path, NanCallback *callback)
    : NanAsyncWorker(callback), bundle(bundle), title(title), path(path) {}
  ~CaptureWindowWorker () {}

  void Execute ();

  void HandleOKCallback () {
    NanScope();

    v8::Local<v8::Value> argv[] = {
      NanNull(),
      NanNew(*path)
    };

    callback->Call(2, argv);
  }

private:
  NanUtf8String bundle;
  NanUtf8String title;
  NanUtf8String path;
};

NAN_METHOD(capture_window) {
  NanScope();

  NanCallback *cb = new NanCallback(args[3].As<v8::Function>());
  NanAsyncQueueWorker(new CaptureWindowWorker(args[0], args[1], args[2], cb));

  NanReturnUndefined();
}

void Initialize(v8::Handle<v8::Object> exports) {
  exports->Set(NanNew("captureWindow"), NanNew<v8::FunctionTemplate>(capture_window)->GetFunction());
}

NODE_MODULE(capture_window, Initialize)
