
#include <Cocoa/Cocoa.h>
#include <CoreGraphics/CGWindow.h>

void CaptureWindowWorker::Execute () {

  uint32_t windowId;
  bool foundWindow = false;

  NSString *nsBundle = [NSString stringWithUTF8String: *bundle];
  NSString *nsTitle = [NSString stringWithUTF8String: *title];

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
    return SetErrorMessage("Failed to find window");
  }

  CGImageRef img = CGWindowListCreateImage(CGRectNull, kCGWindowListOptionIncludingWindow, windowId, kCGWindowImageBoundsIgnoreFraming);
  CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:[NSString stringWithUTF8String: *path]];
  CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);

  if (!destination) {
    return SetErrorMessage("Failed to create CGImageDestination");
  }

  CGImageDestinationAddImage(destination, img, nil);
  bool success = CGImageDestinationFinalize(destination);
  CFRelease(destination);

  if (!success) {
    return SetErrorMessage("Failed to write image");
  }

}
