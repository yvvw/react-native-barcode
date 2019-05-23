#import "RNLBarCodeDecoder.h"
#import "RNLBarCodeUtils.h"

#import <AVFoundation/AVFoundation.h>

#import <React/RCTConvert.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTConvert (RNLBarCodeArguments)

/**
 * Get a still image decoder by decoder id
 *
 * @param json decoder id (NSNumber)
 * @return RNLBarCodeStillImageDecoder instance
 */
+ (nullable id<RNLBarCodeStillImageDecoder>)RNLBarCodeStillImageDecoder:(id)json;

/**
 * Get CGImageRef from image string
 *
 * @param json image string
 * @return CGImageRef instance
 */
+ (nullable CGImageRef)RNLBarCodeCGImageRef:(id)json;

@end

NS_ASSUME_NONNULL_END
