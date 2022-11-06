#include <Cocoa/Cocoa.h>
#include <CoreGraphics/CGWindow.h>

// Failed to find window
#define ERROR_FAILED_TO_FIND_WINDOW 1
// Failed to create CGImageDestination
#define ERROR_FAILED_TO_CREATE_CG_IMAGE_DESTINATION 2
// Failed to write image
#define ERROR_FAILED_TO_WRITE_IMAGE 3
// No access to screen capture
#define ERROR_NO_ACCESS_TO_SCREEN_CAPTURE 4

typedef struct {
  char* bundle;
  char* title;
  char* filename;
  napi_deferred deferred;
  int error_code;
} CaptureData;

void capture_execute(napi_env env, void* _data) {
  CaptureData* data = (CaptureData *) _data;

  if (@available(macOS 10.15, *)) {
    if (!CGPreflightScreenCaptureAccess()) {
      if (!CGRequestScreenCaptureAccess()) {
        data->error_code = ERROR_NO_ACCESS_TO_SCREEN_CAPTURE;
        return;
      }
    }
  }

  uint32_t windowId;
  bool foundWindow = false;

  NSString *nsBundle = [NSString stringWithUTF8String: data->bundle];
  NSString *nsTitle = [NSString stringWithUTF8String: data->title];

  NSArray *windows = (NSArray *) CGWindowListCopyWindowInfo(kCGWindowListExcludeDesktopElements,kCGNullWindowID);

  for (NSDictionary *window in windows) {
    if ([[window objectForKey:(NSString *)kCGWindowOwnerName] isEqualToString:nsBundle]) {
      if ([[window objectForKey:(NSString *)kCGWindowName] isEqualToString:nsTitle]) {
        foundWindow = true;
        windowId = [[window objectForKey:(NSString *)kCGWindowNumber] intValue];
        break;
      }
    }
  }

  if (foundWindow == false) {
    data->error_code = ERROR_FAILED_TO_FIND_WINDOW;
    return;
  }

  CGImageRef img = CGWindowListCreateImage(CGRectNull, kCGWindowListOptionIncludingWindow, windowId, kCGWindowImageBoundsIgnoreFraming);
  CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:[NSString stringWithUTF8String: data->filename]];
  CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);

  if (!destination) {
    data->error_code = ERROR_FAILED_TO_CREATE_CG_IMAGE_DESTINATION;
    return;
  }

  CGImageDestinationAddImage(destination, img, nil);
  bool success = CGImageDestinationFinalize(destination);
  CFRelease(destination);

  if (!success) {
    data->error_code = ERROR_FAILED_TO_WRITE_IMAGE;
    return;
  }
}

void capture_complete(napi_env env, napi_status status, void* _data) {
  CaptureData* data = (CaptureData *) _data;

  switch (data->error_code) {
    case ERROR_FAILED_TO_FIND_WINDOW: {
      napi_value error;
      napi_value error_msg;
      assert(napi_create_string_utf8(env, "Failed to find window", NAPI_AUTO_LENGTH, &error_msg) == napi_ok);
      assert(napi_create_error(env, NULL, error_msg, &error) == napi_ok);
      assert(napi_reject_deferred(env, data->deferred, error) == napi_ok);
      goto cleanup;
    }

    case ERROR_FAILED_TO_CREATE_CG_IMAGE_DESTINATION: {
      napi_value error;
      napi_value error_msg;
      assert(napi_create_string_utf8(env, "Failed to create CGImageDestination", NAPI_AUTO_LENGTH, &error_msg) == napi_ok);
      assert(napi_create_error(env, NULL, error_msg, &error) == napi_ok);
      assert(napi_reject_deferred(env, data->deferred, error) == napi_ok);
      goto cleanup;
    }

    case ERROR_FAILED_TO_WRITE_IMAGE: {
      napi_value error;
      napi_value error_msg;
      assert(napi_create_string_utf8(env, "Failed to write image", NAPI_AUTO_LENGTH, &error_msg) == napi_ok);
      assert(napi_create_error(env, NULL, error_msg, &error) == napi_ok);
      assert(napi_reject_deferred(env, data->deferred, error) == napi_ok);
      goto cleanup;
    }

    case ERROR_NO_ACCESS_TO_SCREEN_CAPTURE: {
      napi_value error;
      napi_value error_msg;
      assert(napi_create_string_utf8(env, "No access to screen capture", NAPI_AUTO_LENGTH, &error_msg) == napi_ok);
      assert(napi_create_error(env, NULL, error_msg, &error) == napi_ok);
      assert(napi_reject_deferred(env, data->deferred, error) == napi_ok);
      goto cleanup;
    }

    case 0: break;
    default: assert(false);
  }

  napi_value result;
  assert(napi_create_string_utf8(env, data->filename, NAPI_AUTO_LENGTH, &result) == napi_ok);
  assert(napi_resolve_deferred(env, data->deferred, result) == napi_ok);

cleanup:
  free(data->bundle);
  free(data->title);
  free(data->filename);
  free(_data);
}

napi_value capture(napi_env env, napi_callback_info info) {
  size_t argc = 3;
  napi_value args[3];
  assert(napi_get_cb_info(env, info, &argc, args, NULL, NULL) == napi_ok);

  CaptureData* data = (CaptureData *) malloc(sizeof(CaptureData));

  data->error_code = 0;

  size_t bundle_length;
  assert(napi_get_value_string_utf8(env, args[0], NULL, 0, &bundle_length) == napi_ok);
  data->bundle = (char *) malloc(bundle_length + 1);
  assert(napi_get_value_string_utf8(env, args[0], data->bundle, bundle_length + 1, NULL) == napi_ok);

  size_t title_length;
  assert(napi_get_value_string_utf8(env, args[1], NULL, 0, &title_length) == napi_ok);
  data->title = (char *) malloc(title_length + 1);
  assert(napi_get_value_string_utf8(env, args[1], data->title, title_length + 1, NULL) == napi_ok);

  size_t filename_length;
  assert(napi_get_value_string_utf8(env, args[2], NULL, 0, &filename_length) == napi_ok);
  data->filename = (char *) malloc(filename_length + 1);
  assert(napi_get_value_string_utf8(env, args[2], data->filename, filename_length + 1, NULL) == napi_ok);

  napi_value promise;
  assert(napi_create_promise(env, &data->deferred, &promise) == napi_ok);

  napi_value work_name;
  assert(napi_create_string_utf8(env, "capture-window", NAPI_AUTO_LENGTH, &work_name) == napi_ok);

  napi_async_work work;
  assert(napi_create_async_work(env, NULL, work_name, capture_execute, capture_complete, (void*) data, &work) == napi_ok);

  assert(napi_queue_async_work(env, work) == napi_ok);

  return promise;
}
