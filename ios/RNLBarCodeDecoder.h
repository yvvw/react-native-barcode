#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define VN_AVAILABLE_VERSION 11.0

NS_ASSUME_NONNULL_BEGIN

typedef NSNumber* RNLBarCodeFormat;
typedef NSDictionary* RNLBarCodeDecodeResult;

/**
 * Still image decoder protocol
 */
@protocol RNLBarCodeStillImageDecoder <NSObject>

@required

/**
 * set formats for decoder
 *
 * @param formats js formats arguments
 */
- (void)setFormats:(NSArray<RNLBarCodeFormat> *)formats;


/**
 * Decode still image
 *
 * @param image CGImageRef instance
 * @param handler decoder result block
 */
- (void)decodeCGImage:(CGImageRef)image withHandler:(void (^)(RNLBarCodeDecodeResult _Nullable result, NSString *_Nullable error)) handler;

@end

/**
 * Vision framework decoder wrapper (iOS 11 available)
 */
__IOS_AVAILABLE(VN_AVAILABLE_VERSION)
@interface RNLBarCodeDecoderVN : NSObject<RNLBarCodeStillImageDecoder>

@end

/**
 * ZBar decoder wrapper
 */
@interface RNLBarCodeDecoderZBar : NSObject<RNLBarCodeStillImageDecoder>

@end

typedef void (^RNLBarCodeAVCallback)(RNLBarCodeDecodeResult _Nonnull result);

/**
 * AVFoundation video decoder wrapper
 */
@interface RNLBarCodeDecoderAV : NSObject<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, readonly, retain) AVCaptureMetadataOutput *output;

/**
 * add symbols to AVCaptureMetadataOutput
 *
 * @note Must be invoked after add output to device, otherwise throw exception
 */
- (void)setFormats:(NSArray<RNLBarCodeFormat> *)formats;

- (void)startDecodeWithQueue:(dispatch_queue_t)queue andResultCallback:(RNLBarCodeAVCallback)callback;

@end

NS_ASSUME_NONNULL_END
