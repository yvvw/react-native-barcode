#import "AVFormat.h"

@implementation AVFormat

#define RAW @"raw"
#define FORMAT @"format"

+ (NSNumber *)getRawFromFormat:(NSString *)format
{
    NSDictionary *allFormats = [self getAllFormats];
    for (NSString *key in allFormats) {
        if ([allFormats[key][FORMAT] isEqualToString:format]) {
            return allFormats[key][RAW];
        }
    }
    return nil;
}

+ (NSArray<AVMetadataObjectType> *)getFormatsFromRawFormats:(NSArray<NSNumber *> *)rawFormats
{
    NSMutableArray *formats = [@[] mutableCopy];
    NSDictionary *allFormats = [self getAllFormats];
    for (NSNumber *rawFormat in rawFormats) {
        for (NSString *key in allFormats) {
            if ([allFormats[key][RAW] integerValue] == [rawFormat integerValue]) {
                [formats addObject:allFormats[key][FORMAT]];
            }
        }
    }
    return formats;
}

+ (NSDictionary *)getAllFormats
{
    return @{
             @"CODE_39":       @{ RAW: @39,  FORMAT: AVMetadataObjectTypeCode39Code },
             @"CODE_93":       @{ RAW: @93,  FORMAT: AVMetadataObjectTypeCode93Code },
             @"CODE_128":      @{ RAW: @128, FORMAT: AVMetadataObjectTypeCode128Code },
             @"EAN_8":         @{ RAW: @8,   FORMAT: AVMetadataObjectTypeEAN8Code },
             @"EAN_13":        @{ RAW: @13,  FORMAT: AVMetadataObjectTypeEAN13Code },
             @"PDF_417":       @{ RAW: @57,  FORMAT: AVMetadataObjectTypePDF417Code },
             @"QR_CODE":       @{ RAW: @64,  FORMAT: AVMetadataObjectTypeQRCode },
             @"UPC_E":         @{ RAW: @9,   FORMAT: AVMetadataObjectTypeUPCECode },
             // customer raw value
             @"AZTEC":         @{ RAW: @70,  FORMAT: AVMetadataObjectTypeAztecCode },
             @"CODE_39_MOD43": @{ RAW: @77,  FORMAT: AVMetadataObjectTypeCode39Mod43Code },
             @"DATA_MATRIX":   @{ RAW: @71,  FORMAT: AVMetadataObjectTypeDataMatrixCode },
             @"ITF":           @{ RAW: @72,  FORMAT: AVMetadataObjectTypeInterleaved2of5Code },
             @"ITF14":         @{ RAW: @78,  FORMAT: AVMetadataObjectTypeCode93Code }
             };
}

@end
