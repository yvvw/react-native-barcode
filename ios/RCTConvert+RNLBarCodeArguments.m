#import "RCTConvert+RNLBarCodeArguments.h"
#import "RNLBarCodeUtils.h"

#import <Foundation/Foundation.h>

@implementation RCTConvert (RNLBarCodeArguments)

+ (nullable id<RNLBarCodeStillImageDecoder>)RNLBarCodeStillImageDecoder:(id)json
{
    NSNumber *decoderID = [RCTConvert NSNumber:json];
    id<RNLBarCodeStillImageDecoder> decoder = nil;
    if ([decoderID isEqualToNumber:@0]) {
        // Auto
        if (@available(iOS VN_AVAILABLE_VERSION, *)) {
            decoder = [RNLBarCodeDecoderVN new];
        } else {
            decoder = [RNLBarCodeDecoderZBar new];
        }
    } else if ([decoderID isEqualToNumber:@2]) {
        // ZBar
        decoder = [RNLBarCodeDecoderZBar new];
    } else if ([decoderID isEqualToNumber:@3]) {
        // Vision
        if (@available(iOS VN_AVAILABLE_VERSION, *)) {
            decoder = [RNLBarCodeDecoderVN new];
        }
    }
    return decoder;
}

+ (nullable CGImageRef)RNLBarCodeCGImageRef:(id)json
{
    NSString *imageStr = [RCTConvert NSString:json];
    if (imageStr == nil) {
        return nil;
    }
    NSData *imageData = RNLParseFileDataFromString(imageStr);
    if (imageData == nil) {
        return nil;
    }
    return [[[UIImage alloc] initWithData:imageData] CGImage];
}

@end
