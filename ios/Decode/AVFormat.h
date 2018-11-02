#ifndef AVFormat_h
#define AVFormat_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVFormat : NSObject

+ (NSNumber *)getRawFromFormat:(NSString *)format;

+ (NSArray<AVMetadataObjectType> *)getFormatsFromRawFormats:(NSArray<NSNumber *> *)rawFormats;

+ (NSDictionary *)getAllFormats;

@end

#endif
