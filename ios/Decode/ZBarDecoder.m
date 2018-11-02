#import "ZBarDecoder.h"

@implementation ZBarDecoder {
    ZBarImageScanner *_scanner;
    NSArray *_formats;
}

#define RAW @"raw"
#define FORMAT @"format"
#define OBJC_FORMAT(intFormat) [NSNumber numberWithInt:intFormat]
#define ENABLE_SYMBOL(symbol) [_scanner setSymbology:symbol config:ZBAR_CFG_ENABLE to:1]
#define DISABLE_SYMBOL(symbol) [_scanner setSymbology:symbol config:ZBAR_CFG_ENABLE to:0]

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scanner = [ZBarImageScanner new];
        [_scanner setSymbology:0 config:ZBAR_CFG_X_DENSITY to:2];
        [_scanner setSymbology:0 config:ZBAR_CFG_Y_DENSITY to:2];
        DISABLE_SYMBOL(ZBAR_NONE);
        _formats = @[];
    }
    return self;
}

- (instancetype)initWithFormats:(NSArray<NSNumber *> *)rawFormats
{
    self = [self init];
    if (self) {
        [self setFormats:rawFormats];
    }
    return self;
}

- (Result *)decode:(UIImage *)image
{
    ZBarImage *zImage = [[ZBarImage alloc] initWithCGImage:image.CGImage];
    NSInteger scanResult = [_scanner scanImage:zImage];
    [zImage cleanup];
    if (scanResult > 0) {
        ZBarSymbol *result = nil;
        ZBarSymbolSet *results = [_scanner results];
        results.filterSymbols = NO;
        for(ZBarSymbol *s in results) {
            if(!result || result.quality < s.quality) {
                result = s;
            }
        }
        NSString *content = [result data];
        // fix messy code
        if ([content canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            content = [NSString
                       stringWithCString:[content cStringUsingEncoding:NSShiftJISStringEncoding]
                       encoding:NSUTF8StringEncoding];
        }
        return [Result initWith:OBJC_FORMAT([result type]) And:content];
    } return nil;
}

- (void)setFormats:(NSArray<NSNumber *> *)rawFormats
{
    if (_formats.count != 0) {
        for (int i = 0; i < _formats.count; i++) {
            DISABLE_SYMBOL([_formats[i] intValue]);
        }
    }
    NSArray *formats = [[self class] getFormatsFrom:rawFormats];
    for (int i = 0; i < formats.count; i++) {
        ENABLE_SYMBOL([formats[i] intValue]);
    }
    _formats = [formats copy];
}

+ (NSDictionary *)getAllSupportFormats
{
    return @{
             @"CODE_39":     @{ RAW: @39,  FORMAT: OBJC_FORMAT(ZBAR_CODE39) },
             @"CODE_93":     @{ RAW: @93,  FORMAT: OBJC_FORMAT(ZBAR_CODE93) },
             @"CODE_128":    @{ RAW: @128, FORMAT: OBJC_FORMAT(ZBAR_CODE128) },
             @"EAN_8":       @{ RAW: @8,   FORMAT: OBJC_FORMAT(ZBAR_EAN8) },
             @"EAN_13":      @{ RAW: @13,  FORMAT: OBJC_FORMAT(ZBAR_EAN13) },
             @"PDF_417":     @{ RAW: @57,  FORMAT: OBJC_FORMAT(ZBAR_PDF417) },
             @"QR_CODE":     @{ RAW: @64,  FORMAT: OBJC_FORMAT(ZBAR_QRCODE) },
             @"UPC_E":       @{ RAW: @9,   FORMAT: OBJC_FORMAT(ZBAR_UPCE) },
             // customer raw value
             @"COMPOSITE":   @{ RAW: @15,  FORMAT: OBJC_FORMAT(ZBAR_COMPOSITE) },
             @"DATABAR":     @{ RAW: @34,  FORMAT: OBJC_FORMAT(ZBAR_DATABAR) },
             @"DATABAR_EXP": @{ RAW: @35,  FORMAT: OBJC_FORMAT(ZBAR_DATABAR_EXP) },
             @"EAN_2":       @{ RAW: @2,   FORMAT: OBJC_FORMAT(ZBAR_EAN2) },
             @"EAN_5":       @{ RAW: @5,   FORMAT: OBJC_FORMAT(ZBAR_EAN5) },
             @"I_25":        @{ RAW: @25,  FORMAT: OBJC_FORMAT(ZBAR_I25) },
             @"ISBN_10":     @{ RAW: @10,  FORMAT: OBJC_FORMAT(ZBAR_ISBN10) },
             @"ISBN_13":     @{ RAW: @14,  FORMAT: OBJC_FORMAT(ZBAR_ISBN13) },
             @"UPC_A":       @{ RAW: @12,  FORMAT: OBJC_FORMAT(ZBAR_UPCA) }
             };
}

+ (NSArray<NSNumber *> *)getFormatsFrom:(NSArray<NSNumber *> *)rawFormats
{
    NSDictionary *allSupportFormats = [self getAllSupportFormats];
    NSMutableArray *formats = [@[] mutableCopy];
    for (NSNumber *rawFormat in rawFormats) {
        for (NSString *key in allSupportFormats) {
            NSDictionary *supportFormat = allSupportFormats[key];
            if ([supportFormat[RAW] isEqualToNumber:rawFormat]) {
                [formats addObject:supportFormat[FORMAT]];
            }
        }
    }
    return formats;
}

@end
