#include <assert.h>

#define NAPI_VERSION 1
#include <node_api.h>

#ifdef __APPLE__
#include "apple.m"
#else
#error Platform not supported
#endif

static napi_value Init(napi_env env, napi_value exports) {
  napi_value result;
  assert(napi_create_object(env, &result) == napi_ok);

  napi_value capture_fn;
  assert(napi_create_function(env, "capture", NAPI_AUTO_LENGTH, capture, NULL, &capture_fn) == napi_ok);
  assert(napi_set_named_property(env, result, "capture", capture_fn) == napi_ok);

  return result;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, Init)
