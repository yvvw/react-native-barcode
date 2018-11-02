#import <UIKit/UIKit.h>

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import "Decode/ZBarDecoder.h"
#import "Decode/Result.h"
#import "Util/ImageUtils.h"
#import "Error.h"

@interface RCTBarcode : NSObject <RCTBridgeModule>

@end

@implementation RCTBarcode

RCT_REMAP_METHOD(base64,
                 decodeBase64String:(NSString *)input
                 withFormats:(NSArray *)rawFormats
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:input options:0];
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil) {
        [self decodeImage:image withFormats:rawFormats resolver:resolve rejecter:reject];
    } else {
        reject(ERROR_CODE(DECODE_FAILED), @"Decode image data failed.", nil);
    }
}

RCT_REMAP_METHOD(image,
                 decodeImageUrl:(NSString *)imageString
                 withFormats:(NSArray *)rawFormats
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    UIImage *image = nil;
    if ([imageString hasPrefix:@"/"]) {
        image = [UIImage imageWithContentsOfFile:imageString];
    }
    if (image == nil) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
    }
    if (image != nil) {
        [self decodeImage:image withFormats:rawFormats resolver:resolve rejecter:reject];
    } else {
        reject(ERROR_CODE(FILE_NOT_FOUND), @"File not found.", nil);
    }
}

RCT_REMAP_METHOD(screenshot,
                 decodeScreenshotWithFormats:(NSArray *)rawFormats
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.layer renderInContext:ctx];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (screenshot != nil) {
        [self decodeImage:screenshot withFormats:rawFormats resolver:resolve rejecter:reject];
    } else {
        reject(ERROR_CODE(DECODE_FAILED), @"Take screenshot failed.", nil);
    }
}

- (void)decodeImage:(UIImage *)image
        withFormats:(NSArray *)rawFormats
           resolver:(RCTPromiseResolveBlock)resolve
           rejecter:(RCTPromiseRejectBlock)reject
{
    ZBarDecoder *decoder = [[ZBarDecoder alloc] initWithFormats:rawFormats];
    image = [ImageUtils compressImage:image toSize:CGSizeMake(600, 600)];
    if (image == nil) {
        reject(ERROR_CODE(DECODE_FAILED), @"Image compress failed.", nil);
        return;
    }
    Result *result = [decoder decode:image];
    if (result != nil) {
        resolve(@{ @"type": result.raw, @"content": result.content});
    } else {
        reject(ERROR_CODE(BARCODE_NOT_FOUND), @"Barcode not found.", nil);
    }
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

@end
