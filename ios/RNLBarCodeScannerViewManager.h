#import "RNLBarCodeScannerView.h"

#import <AVFoundation/AVFoundation.h>

#import <React/RCTViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNLBarCodeScannerViewManager : RCTViewManager

@property (nullable, nonatomic, readonly) AVCaptureDevice *device;

@property (nonatomic, readonly) AVCaptureSession *session;

@end

NS_ASSUME_NONNULL_END
