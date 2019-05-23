#import "RNLBarCodeScannerViewManager.h"
#import "RNLBarCodeScannerView.h"
#import "RNLBarCodeUtils.h"

#import <React/RCTUtils.h>

@interface RNLBarCodeScannerViewManager ()

@end

@implementation RNLBarCodeScannerViewManager

@synthesize methodQueue = _methodQueue;
@synthesize device = _device;
@synthesize session = _session;

RCT_EXPORT_MODULE(RNLBarCodeScannerView)

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXPORT_VIEW_PROPERTY(enable, BOOL)

RCT_EXPORT_VIEW_PROPERTY(decoderID, NSNumber)

RCT_EXPORT_VIEW_PROPERTY(formats, NSArray)

RCT_EXPORT_VIEW_PROPERTY(torch, NSNumber)

RCT_EXPORT_VIEW_PROPERTY(onResult, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock)

- (UIView *)view
{
    RNLBarCodeScannerView *view = [RNLBarCodeScannerView new];
    // weak property
    view.manager = self;
    return view;
}

- (AVCaptureDevice *)device
{
    if (_device == nil) {
        NSArray<AVCaptureDevice *> *devices;
        if (@available(iOS 10.0, *)) {
            AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
            devices = session.devices;
        } else {
            devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        }
        if (devices.count > 0) {
            _device = [devices firstObject];
            for (int i = 1; i < [devices count]; i++) {
                if ([devices objectAtIndex:i].position == AVCaptureDevicePositionBack) {
                    _device = [devices objectAtIndex:i];
                }
            }
        }
    }
    return _device;
}

- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [AVCaptureSession new];
    }
    return _session;
}

@end
