#import "RNLBarCodeDecoder.h"
#import "RNLBarCodeUtils.h"

#import <ZBarSDK/ZBarSDK.h>

#define ZBAR_DENSITY 2

@interface RNLBarCodeDecoderZBar ()

@property (nonatomic, retain) ZBarImageScanner* scanner;

- (zbar_symbol_type_t)convertFormatToSymbol:(RNLBarCodeFormat)format;

- (nullable RNLBarCodeFormat)convertSymbolToFormat:(zbar_symbol_type_t)symbol;

@end

@implementation RNLBarCodeDecoderZBar

@synthesize scanner = _scanner;

- (instancetype)init
{
  self = [super init];
  if (self) {
    _scanner = [ZBarImageScanner new];
    [_scanner setSymbology: 0
                   config: ZBAR_CFG_X_DENSITY
                       to: ZBAR_DENSITY];
    [_scanner setSymbology: 0
                   config: ZBAR_CFG_Y_DENSITY
                       to: ZBAR_DENSITY];
  }
  return self;
}

- (void)setFormats:(NSArray<RNLBarCodeFormat> *)formats
{
  if ([formats count] > 0) {
      // clear all symbol
      [_scanner setSymbology:ZBAR_NONE config:ZBAR_CFG_ENABLE to:0];
      for (RNLBarCodeFormat format in formats) {
          zbar_symbol_type_t symbol = [self convertFormatToSymbol:format];
          if ((int)symbol != -1) {
              [_scanner setSymbology:symbol config:ZBAR_CFG_ENABLE to:1];
          }
      }
  } else {
      // set all symbol
      [_scanner setSymbology:ZBAR_NONE config:ZBAR_CFG_ENABLE to:1];
  }
}

- (void)decodeCGImage:(CGImageRef)image withHandler:(void (^)(RNLBarCodeDecodeResult _Nullable, NSString * _Nullable))handler
{
    ZBarImage *zImage = [[ZBarImage alloc] initWithCGImage:image];
    if ([_scanner scanImage:zImage]) {
        for (ZBarSymbol *result in _scanner.results) {
            handler(@{
                      @"format": [self convertSymbolToFormat:result.type],
                      @"content": RNLConvertShiftJISToUTF8(result.data)
                      }, nil);
            return;
        }
    }
    handler(nil, @"Not Found");
}

- (zbar_symbol_type_t)convertFormatToSymbol:(RNLBarCodeFormat)format
{
    if ([format isEqualToNumber:@2]) {
        return ZBAR_EAN2;
    } else if ([format isEqualToNumber:@5]) {
        return ZBAR_EAN5;
    } else if ([format isEqualToNumber:@8]) {
        return ZBAR_EAN8;
    } else if ([format isEqualToNumber:@9]) {
        return ZBAR_UPCE;
    } else if ([format isEqualToNumber:@10]) {
        return ZBAR_ISBN10;
    } else if ([format isEqualToNumber:@12]) {
        return ZBAR_UPCA;
    } else if ([format isEqualToNumber:@13]) {
        return ZBAR_EAN13;
    } else if ([format isEqualToNumber:@14]) {
        return ZBAR_ISBN13;
    } else if ([format isEqualToNumber:@15]) {
        return ZBAR_COMPOSITE;
    } else if ([format isEqualToNumber:@25]) {
        return ZBAR_I25;
    } else if ([format isEqualToNumber:@34]) {
        return ZBAR_DATABAR;
    } else if ([format isEqualToNumber:@35]) {
        return ZBAR_DATABAR_EXP;
    } else if ([format isEqualToNumber:@38]) {
        return ZBAR_CODABAR;
    } else if ([format isEqualToNumber:@39]) {
        return ZBAR_CODE39;
    } else if ([format isEqualToNumber:@57]) {
        return ZBAR_PDF417;
    } else if ([format isEqualToNumber:@64]) {
        return ZBAR_QRCODE;
    } else if ([format isEqualToNumber:@93]) {
        return ZBAR_CODE93;
    } else if ([format isEqualToNumber:@128]) {
        return ZBAR_CODE128;
    }
    return -1;
}

- (RNLBarCodeFormat)convertSymbolToFormat:(zbar_symbol_type_t)symbol
{
    if (ZBAR_EAN2 == symbol) {
        return @2;
    } else if (ZBAR_EAN5 == symbol) {
        return @5;
    } else if (ZBAR_EAN8 == symbol) {
        return @8;
    } else if (ZBAR_UPCE == symbol) {
        return @9;
    } else if (ZBAR_ISBN10 == symbol) {
        return @10;
    } else if (ZBAR_UPCA == symbol) {
        return @12;
    } else if (ZBAR_EAN13 == symbol) {
        return @13;
    } else if (ZBAR_ISBN13 == symbol) {
        return @14;
    } else if (ZBAR_COMPOSITE == symbol) {
        return @15;
    } else if (ZBAR_I25 == symbol) {
        return @25;
    } else if (ZBAR_DATABAR == symbol) {
        return @34;
    } else if (ZBAR_DATABAR_EXP == symbol) {
        return @35;
    } else if (ZBAR_CODABAR == symbol) {
        return @38;
    } else if (ZBAR_CODE39 == symbol) {
        return @39;
    } else if (ZBAR_PDF417 == symbol) {
        return @57;
    } else if (ZBAR_QRCODE == symbol) {
        return @64;
    } else if (ZBAR_CODE93 == symbol) {
        return @93;
    } else if (ZBAR_CODE128 == symbol) {
        return @128;
    }
    return nil;
}

@end

#undef ZBAR_DENSITY
