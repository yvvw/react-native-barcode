#import "RNLBarCodeModule.h"
#import "RNLBarCodeDecoder.h"
#import "RNLBarCodeUtils.h"
#import "RCTConvert+RNLBarCodeArguments.h"

#import <React/RCTConvert.h>

/**
 * Generate string error code from int
 *
 * @param error RNLBarCodeError enum
 * @return error code string
 */
NSString* RNLBarCodeGetErrorCodeString(RNLBarCodeError error);

@interface RNLBarCodeModule ()

@end

@implementation RNLBarCodeModule

RCT_EXPORT_MODULE(RNLBarCode)

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_REMAP_METHOD(decode,
                 decodeWithOption:(NSDictionary *)option
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    id<RNLBarCodeStillImageDecoder> decoder = [RCTConvert RNLBarCodeStillImageDecoder:option[@"decoder"]];
    if (decoder == nil) {
        reject(RNLBarCodeGetErrorCodeString(RNLBarCodeInvokeFailedError),
               @"Device doesn't support this decoder", nil);
        return;
    }

    NSArray *formats = [RCTConvert NSArray:option[@"formats"]];
    if (formats == nil) {
        reject(RNLBarCodeGetErrorCodeString(RNLBarCodeInvokeFailedError),
               @"Decode formats is invalid", nil);
        return;
    }
    [decoder setFormats:formats];
    
    CGImageRef image;
    if ([RCTConvert BOOL:option[@"screenshot"]]) {
        __block UIImage *screenshot;
        dispatch_sync(dispatch_get_main_queue(), ^{
            RNLTakeScreenshot(&screenshot);
        });
        image = screenshot.CGImage;
    } else {
        image = [RCTConvert RNLBarCodeCGImageRef:option[@"data"]];
    }
    if (image == nil) {
        reject(RNLBarCodeGetErrorCodeString(RNLBarCodeInvokeFailedError),
               @"Parse image string failed", nil);
        return;
    }
    
    [decoder decodeCGImage:image withHandler:^(RNLBarCodeDecodeResult _Nullable result, NSString * _Nullable error) {
        if (error != nil) {
            reject(RNLBarCodeGetErrorCodeString(RNLBarCodeInvokeFailedError), error, nil);
        } else {
            resolve(result);
        }
    }];
}

@end

NSString* RNLBarCodeGetErrorCodeString(RNLBarCodeError error) {
    return [NSString stringWithFormat:@"%ld", (long)error];
}
