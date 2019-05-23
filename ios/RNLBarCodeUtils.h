#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <React/RCTDefines.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Parse string from js to NSData
 *
 * @param aString a string start with [https?|file|data] schemes or
                  [~|/] path separator or pure base64 string data be used to parse
 * @return NSData object
 */
NSData *_Nullable RNLParseFileDataFromString(NSString *aString);

/**
 * Draw UIWindow to UIImage
 */
void RNLTakeScreenshot(UIImage *_Nullable *_Nonnull image);

/**
 * Convert ShiftJIS encoding string to UTF-8 encoding string
 */
NSString *RNLConvertShiftJISToUTF8(NSString *aString);

NS_ASSUME_NONNULL_END

