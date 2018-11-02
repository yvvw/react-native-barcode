#ifndef ZBarDecoder_h
#define ZBarDecoder_h

#import <Foundation/Foundation.h>
#if __has_include("ZBarSDK.h")
#import "ZBarSDK.h"
#else
#import <ZBarSDK/ZBarSDK.h>
#endif
#import "Result.h"

@interface ZBarDecoder : NSObject

- (instancetype)initWithFormats:(NSArray<NSNumber *> *)rawFormats;

- (void)setFormats:(NSArray<NSNumber *> *)rawFormats;

- (Result *)decode:(UIImage *)image;

@end

#endif
