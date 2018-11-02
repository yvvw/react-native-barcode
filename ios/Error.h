#ifdef __OBJC__

#import <Foundation/Foundation.h>

#define ERROR_CODE(code) [NSString stringWithFormat:@"%d", code]

typedef NS_ENUM(int, Error) {
    BARCODE_NOT_FOUND = -1,
    DECODE_FAILED = -2,
    FILE_NOT_FOUND = -3,
    NOT_GRANT_READ_IMAGE = -4,
    NOT_GRANT_USE_CAMERA = -5,
    DEVICE_NO_CAMERA = -6
};

#endif
