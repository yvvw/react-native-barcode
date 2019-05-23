#import "RNLBarCodeUtils.h"

#import <React/RCTConvert.h>
#import <React/RCTUtils.h>

NSData *_Nullable RNLParseFileDataFromString(NSString *aString) {
    NSString *aStringCopy = [aString copy];
    if ([aStringCopy hasPrefix:@"~"] ||
      [aStringCopy hasPrefix:@"/"] ||
      [aStringCopy hasPrefix:@"file"] ||
      [aStringCopy hasPrefix:@"http"]) {
        NSURL *url = [RCTConvert NSURL:aStringCopy];
        return [NSData dataWithContentsOfURL:url];
    } else if ([aStringCopy hasPrefix:@"data:"]) {
        aStringCopy = [aStringCopy substringFromIndex:[aStringCopy rangeOfString:@","].location + 1];
    }
    return [[NSData alloc] initWithBase64EncodedString:aStringCopy
                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

void RNLTakeScreenshot(UIImage *_Nullable *_Nonnull image) {
    // https://developer.apple.com/library/archive/qa/qa1703/_index.html
    if (RCTSharedApplication() == nil) return;
    UIGraphicsBeginImageContextWithOptions(RCTScreenSize(), NO, 0);
    CGContextRef aContext = UIGraphicsGetCurrentContext();
    for (UIWindow *aWindow in RCTSharedApplication().windows) {
        if (![aWindow respondsToSelector:@selector(screen)] ||
            [aWindow screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(aContext);
            CGContextTranslateCTM(aContext, [aWindow center].x, [aWindow center].y);
            CGContextConcatCTM(aContext, [aWindow transform]);
            CGContextTranslateCTM(aContext,
                                  -[aWindow bounds].size.width * [[aWindow layer] anchorPoint].x,
                                  -[aWindow bounds].size.height * [[aWindow layer] anchorPoint].y);
            [[aWindow layer] renderInContext:aContext];
            CGContextRestoreGState(aContext);
        }
    }
    *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

NSString *RNLConvertShiftJISToUTF8(NSString *aString) {
    NSString *stringCopy = [aString copy];
    if ([stringCopy canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
        stringCopy = [NSString stringWithCString:[stringCopy cStringUsingEncoding:NSShiftJISStringEncoding]
                                     encoding:NSUTF8StringEncoding];
    }
    return stringCopy;
}
