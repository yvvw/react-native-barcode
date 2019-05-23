#import "RNLBarCodeScannerViewManager.h"

#import <UIKit/UIKit.h>

#import <React/RCTComponent.h>

NS_ASSUME_NONNULL_BEGIN

@class RNLBarCodeScannerViewManager;

@interface RNLBarCodeScannerView : UIView

@property (nullable, nonatomic, weak) RNLBarCodeScannerViewManager *manager;

@property (nonatomic, assign) BOOL enable;

@property (nullable, nonatomic, retain) NSNumber *decoderID;

@property (nullable, nonatomic, retain) NSArray<NSNumber *> *formats;

@property (nullable, nonatomic, assign) NSNumber *torch;

@property (nullable, nonatomic, copy) RCTDirectEventBlock onResult;

@property (nullable, nonatomic, copy) RCTDirectEventBlock onError;

@end

NS_ASSUME_NONNULL_END
