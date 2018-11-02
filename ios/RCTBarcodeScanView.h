#ifndef RCTBarcodeScanView_h
#define RCTBarcodeScanView_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#if __has_include("RCTComponent.h")
#import "RCTComponent.h"
#else
#import <React/RCTComponent.h>
#endif

#import "Decode/AVFormat.h"
#import "Error.h"

@interface RCTBarcodeScanView : UIView<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL flash;
@property (nonatomic, assign) BOOL autoFocus;
@property (nonatomic, retain) NSArray<AVMetadataObjectType> *formats;
@property (nonatomic, assign) CGSize scanSize;
@property (nonatomic, copy) RCTDirectEventBlock onScan;
@property (nonatomic, copy) RCTDirectEventBlock onError;

@end

#endif
