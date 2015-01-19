
#include <Cocoa/Cocoa.h>
#include <CoreGraphics/CGWindow.h>

NAN_METHOD(get_window_id) {
  NanScope();

  NanUtf8String uBundle(args[0]);
  NanUtf8String uTitle(args[1]);

  NSString *nsBundle = [NSString stringWithUTF8String: *uBundle];
  NSString *nsTitle = [NSString stringWithUTF8String: *uTitle];

  NSArray *windows = (NSArray *) CGWindowListCopyWindowInfo(kCGWindowListExcludeDesktopElements,kCGNullWindowID);

  for (NSDictionary *window in windows) {
    if ([[window objectForKey:(NSString *)kCGWindowOwnerName] isEqualToString:nsBundle]) {
      if ([[window objectForKey:(NSString *)kCGWindowName] isEqualToString:nsTitle]) {
        NanReturnValue(NanNew<v8::Integer>([[window objectForKey:(NSString *)kCGWindowNumber] intValue]));
      }
    }
  }

  NanReturnUndefined();
}
