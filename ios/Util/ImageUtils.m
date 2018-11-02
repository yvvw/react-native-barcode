#import "ImageUtils.h"

@implementation ImageUtils

+ (UIImage *)compressImage:(UIImage *)image toSize:(CGSize)maxSize
{
    UIImage *compressImage = image;
    CGSize originSize = image.size;
    if (originSize.width < maxSize.width && originSize.height < maxSize.height) {
        return compressImage;
    }
    // calc scale size
    CGSize scaledSize = originSize;
    if (originSize.width > maxSize.width) {
        scaledSize = CGSizeMake(maxSize.width, (maxSize.width / scaledSize.width) * scaledSize.height);
    }
    if (originSize.height > maxSize.height) {
        scaledSize = CGSizeMake((maxSize.height / scaledSize.height) * scaledSize.width, maxSize.height);
    }
    scaledSize.width = (int)scaledSize.width;
    scaledSize.height = (int)scaledSize.height;
    
    // compress
    UIGraphicsBeginImageContext(scaledSize);
    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    compressImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressImage;
}

@end
