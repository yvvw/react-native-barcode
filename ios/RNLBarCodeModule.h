#import <React/RCTBridgeModule.h>

/**
 * BarCode module error code
 *
 * - RNLBarCodeInvokeFailedError: Invoke failed error
 */
typedef NS_ENUM(NSInteger, RNLBarCodeError) {
    RNLBarCodeInvokeFailedError = -1,
    RNLBarCodeNoCameraPermission = -2,
    RNLBarCodeNoCameraDevice = -3,
};

/**
 * BarCode module for react native
 */
@interface RNLBarCodeModule : NSObject <RCTBridgeModule>

@end
