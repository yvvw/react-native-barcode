#if __has_include("RCTViewManager.h")
#import "RCTViewManager.h"
#else
#import <React/RCTViewManager.h>
#endif

#import "RCTBarcodeScanView.h"

@interface RCTBarcodeScanViewManager : RCTViewManager

@end

@implementation RCTBarcodeScanViewManager

- (UIView *)view
{
    return [RCTBarcodeScanView new];
}

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(enable, BOOL);
RCT_EXPORT_VIEW_PROPERTY(formats, NSArray);
RCT_EXPORT_VIEW_PROPERTY(flash, BOOL);
RCT_EXPORT_VIEW_PROPERTY(autoFocus, BOOL);
RCT_EXPORT_VIEW_PROPERTY(onScan, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock);

RCT_CUSTOM_VIEW_PROPERTY(scanSize, NSDictionary, RCTBarcodeScanView)
{
    NSDictionary *scanSize = [RCTConvert NSDictionary:json];
    NSNumber *width = [scanSize valueForKey:@"width"];
    NSNumber *height = [scanSize valueForKey:@"height"];
    [view setScanSize:CGSizeMake((CGFloat)[width doubleValue], (CGFloat)[height doubleValue])];
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

@end
