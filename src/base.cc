
#include <napi.h>

class CaptureWindowWorker : public Napi::AsyncWorker {
public:
  CaptureWindowWorker (std::string bundle, std::string title, std::string path, Napi::Function &callback)
    : Napi::AsyncWorker(callback), bundle(bundle), title(title), path(path) {}
  ~CaptureWindowWorker () {}

  void Execute ();

  void OnOK () {
    Callback().Call({ Env().Null(), Napi::String::New(Env(), path) });
  }

private:
  std::string bundle;
  std::string title;
  std::string path;
};

Napi::Value capture_window(const Napi::CallbackInfo &info) {
  Napi::Function cb = info[3].As<Napi::Function>();
  (new CaptureWindowWorker(info[0].As<Napi::String>(), info[1].As<Napi::String>(), info[2].As<Napi::String>(), cb))->Queue();
  return info.Env().Undefined();
}

Napi::Object Initialize(Napi::Env env, Napi::Object exports) {
  exports["captureWindow"] = Napi::Function::New(env, capture_window);
  return exports;
}

NODE_API_MODULE(capture_window, Initialize)
