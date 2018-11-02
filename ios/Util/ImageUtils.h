#ifndef ImageUtils_h
#define ImageUtils_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUtils : NSObject

+ (UIImage *)compressImage:(UIImage *)image toSize:(CGSize)maxSize;

@end

#endif
