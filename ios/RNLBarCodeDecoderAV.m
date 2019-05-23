#import "RNLBarCodeDecoder.h"

#import <Foundation/Foundation.h>

@interface RNLBarCodeDecoderAV ()

@property (nonatomic, copy) RNLBarCodeAVCallback callback;

- (nullable AVMetadataObjectType)convertFormatToSymbol:(RNLBarCodeFormat)format;

- (nullable RNLBarCodeFormat)convertSymbolToFormat:(AVMetadataObjectType)symbol;

@end

@implementation RNLBarCodeDecoderAV

@synthesize output = _output;
@synthesize callback = _callback;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _output = [AVCaptureMetadataOutput new];
    }
    return self;
}

- (void)setFormats:(NSArray<RNLBarCodeFormat> *_Nonnull)formats
{
    NSMutableArray<AVMetadataObjectType> *symbols = [NSMutableArray new];
    if (formats.count > 0) {
        for (RNLBarCodeFormat format in formats) {
            AVMetadataObjectType result = [self convertFormatToSymbol:format];
            if (result) {
                [symbols addObject:(AVMetadataObjectType)result];
            }
        }
    }
    if (formats.count == 0) {
        static NSArray<AVMetadataObjectType> *allSymbols;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            allSymbols = @[
                           AVMetadataObjectTypeAztecCode,
                           AVMetadataObjectTypeCode128Code,
                           AVMetadataObjectTypeCode39Code,
                           AVMetadataObjectTypeCode39Mod43Code,
                           AVMetadataObjectTypeCode93Code,
                           AVMetadataObjectTypeDataMatrixCode,
                           AVMetadataObjectTypeEAN13Code,
                           AVMetadataObjectTypeEAN8Code,
                           AVMetadataObjectTypeInterleaved2of5Code,
                           AVMetadataObjectTypeITF14Code,
                           AVMetadataObjectTypePDF417Code,
                           AVMetadataObjectTypeQRCode,
                           AVMetadataObjectTypeUPCECode,
                           ];
        });
        [symbols addObjectsFromArray:allSymbols];
    }
    _output.metadataObjectTypes = symbols;
}

- (void)startDecodeWithQueue:(dispatch_queue_t)queue andResultCallback:(RNLBarCodeAVCallback)callback
{
    __weak RNLBarCodeDecoderAV *weakSelf = self;
    [_output setMetadataObjectsDelegate:weakSelf queue:queue];
    _callback = callback;
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
  for (AVMetadataObject *object in metadataObjects) {
    if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        if (_callback != nil) {
            _callback(@{
                        @"format": [self convertSymbolToFormat:object.type],
                        @"content": [(AVMetadataMachineReadableCodeObject *)object stringValue]
                        });
        }
    }
  }
}

- (nullable RNLBarCodeFormat)convertSymbolToFormat:(AVMetadataObjectType)symbol;
{
    if (AVMetadataObjectTypeAztecCode == symbol) {
        return @225;
    } else if (AVMetadataObjectTypeCode128Code == symbol) {
        return @128;
    } else if (AVMetadataObjectTypeCode39Code == symbol) {
        return @39;
    } else if (AVMetadataObjectTypeCode39Mod43Code == symbol) {
        return @106;
    } else if (AVMetadataObjectTypeCode93Code == symbol) {
        return @93;
    } else if (AVMetadataObjectTypeDataMatrixCode == symbol) {
        return @200;
    } else if (AVMetadataObjectTypeEAN13Code == symbol) {
        return @13;
    } else if (AVMetadataObjectTypeEAN8Code == symbol) {
        return @8;
    } else if (AVMetadataObjectTypeInterleaved2of5Code == symbol) {
        return @25;
    } else if (AVMetadataObjectTypeITF14Code == symbol) {
        return @45;
    } else if (AVMetadataObjectTypePDF417Code == symbol) {
        return @57;
    } else if (AVMetadataObjectTypeQRCode == symbol) {
        return @64;
    } else if (AVMetadataObjectTypeUPCECode == symbol) {
        return @9;
    }
    return nil;
}

- (nullable AVMetadataObjectType)convertFormatToSymbol:(RNLBarCodeFormat)format;
{
    if ([format isEqualToNumber:@225]) {
        return AVMetadataObjectTypeAztecCode;
    } else if ([format isEqualToNumber:@128]) {
        return AVMetadataObjectTypeCode128Code;
    } else if ([format isEqualToNumber:@39]) {
        return AVMetadataObjectTypeCode39Code;
    } else if ([format isEqualToNumber:@106]) {
        return AVMetadataObjectTypeCode39Mod43Code;
    } else if ([format isEqualToNumber:@93]) {
        return AVMetadataObjectTypeCode93Code;
    } else if ([format isEqualToNumber:@200]) {
        return AVMetadataObjectTypeDataMatrixCode;
    } else if ([format isEqualToNumber:@13]) {
        return AVMetadataObjectTypeEAN13Code;
    } else if ([format isEqualToNumber:@8]) {
        return AVMetadataObjectTypeEAN8Code;
    } else if ([format isEqualToNumber:@25]) {
        return AVMetadataObjectTypeInterleaved2of5Code;
    } else if ([format isEqualToNumber:@45]) {
        return AVMetadataObjectTypeITF14Code;
    } else if ([format isEqualToNumber:@57]) {
        return AVMetadataObjectTypePDF417Code;
    } else if ([format isEqualToNumber:@64]) {
        return AVMetadataObjectTypeQRCode;
    } else if ([format isEqualToNumber:@9]) {
        return AVMetadataObjectTypeUPCECode;
    }
    return nil;
}

@end
