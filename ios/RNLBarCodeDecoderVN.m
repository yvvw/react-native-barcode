#import "RNLBarCodeDecoder.h"

@import Vision;

@interface RNLBarCodeDecoderVN ()

@property (nonatomic, retain) NSMutableArray<VNBarcodeSymbology> *symbols;

- (VNBarcodeSymbology)convertFormatToSymbol:(RNLBarCodeFormat)format;

- (nullable RNLBarCodeFormat)convertSymbolToFormat:(VNBarcodeSymbology)symbol;

@end

@implementation RNLBarCodeDecoderVN

@synthesize symbols = _symbols;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _symbols = [NSMutableArray new];
    }
    return self;
}

- (void)setFormats:(NSArray<RNLBarCodeFormat> *)formats
{
    [_symbols removeAllObjects];
    if ([formats count] > 0) {
        for (RNLBarCodeFormat format in formats) {
            NSString *result = [self convertFormatToSymbol:format];
            if (result != nil) {
                [_symbols addObject:(VNBarcodeSymbology)result];
            }
        }
    }
}

- (void)decodeCGImage:(CGImageRef)image withHandler:(void (^)(RNLBarCodeDecodeResult _Nullable, NSString * _Nullable))handler
{
    VNDetectBarcodesRequest *detectRequest = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError *error) {
        if (error != nil) {
            handler(nil, [NSString stringWithFormat:@"%@", error]);
        } else {
            VNBarcodeObservation *result = request.results.firstObject;
            handler(@{
                      @"format": [self convertSymbolToFormat:result.symbology],
                      @"content": result.payloadStringValue
                      }, nil);
        }
    }];
    if (_symbols.count != 0) {
        detectRequest.symbologies = _symbols;
    }
    [[[VNImageRequestHandler alloc] initWithCGImage:image options:@{}] performRequests:@[detectRequest] error:nil];
}

- (VNBarcodeSymbology)convertFormatToSymbol:(RNLBarCodeFormat)format
{
    if ([format isEqualToNumber:@225]) {
        return VNBarcodeSymbologyAztec;
    } else if ([format isEqualToNumber:@39]) {
        return VNBarcodeSymbologyCode39;
    } else if ([format isEqualToNumber:@51]) {
        return VNBarcodeSymbologyCode39Checksum;
    } else if ([format isEqualToNumber:@289]) {
        return VNBarcodeSymbologyCode39FullASCII;
    } else if ([format isEqualToNumber:@4051]) {
        return VNBarcodeSymbologyCode39FullASCIIChecksum;
    } else if ([format isEqualToNumber:@93]) {
        return VNBarcodeSymbologyCode93;
    } else if ([format isEqualToNumber:@931]) {
        return VNBarcodeSymbologyCode93i;
    } else if ([format isEqualToNumber:@128]) {
        return VNBarcodeSymbologyCode128;
    } else if ([format isEqualToNumber:@200]) {
        return VNBarcodeSymbologyDataMatrix;
    } else if ([format isEqualToNumber:@8]) {
        return VNBarcodeSymbologyEAN8;
    } else if ([format isEqualToNumber:@13]) {
        return VNBarcodeSymbologyEAN13;
    } else if ([format isEqualToNumber:@25]) {
        return VNBarcodeSymbologyI2of5;
    } else if ([format isEqualToNumber:@37]) {
        return VNBarcodeSymbologyI2of5Checksum;
    } else if ([format isEqualToNumber:@45]) {
        return VNBarcodeSymbologyITF14;
    } else if ([format isEqualToNumber:@57]) {
        return VNBarcodeSymbologyPDF417;
    } else if ([format isEqualToNumber:@64]) {
        return VNBarcodeSymbologyQR;
    } else if ([format isEqualToNumber:@9]) {
        return VNBarcodeSymbologyUPCE;
    }
    return nil;
}

- (nullable RNLBarCodeFormat)convertSymbolToFormat:(VNBarcodeSymbology)symbol
{
    if ([VNBarcodeSymbologyAztec isEqualToString:symbol]) {
        return @225;
    } else if ([VNBarcodeSymbologyCode39 isEqualToString:symbol]) {
        return @39;
    } else if ([VNBarcodeSymbologyCode39Checksum isEqualToString:symbol]) {
        return @51;
    } else if ([VNBarcodeSymbologyCode39FullASCII isEqualToString:symbol]) {
        return @289;
    } else if ([VNBarcodeSymbologyCode39FullASCIIChecksum isEqualToString:symbol]) {
        return @4051;
    } else if ([VNBarcodeSymbologyCode93 isEqualToString:symbol]) {
        return @93;
    } else if ([VNBarcodeSymbologyCode93i isEqualToString:symbol]) {
        return @931;
    } else if ([VNBarcodeSymbologyCode128 isEqualToString:symbol]) {
        return @128;
    } else if ([VNBarcodeSymbologyDataMatrix isEqualToString:symbol]) {
        return @200;
    } else if ([VNBarcodeSymbologyEAN8 isEqualToString:symbol]) {
        return @8;
    } else if ([VNBarcodeSymbologyEAN13 isEqualToString:symbol]) {
        return @13;
    } else if ([VNBarcodeSymbologyI2of5 isEqualToString:symbol]) {
        return @25;
    } else if ([VNBarcodeSymbologyI2of5Checksum isEqualToString:symbol]) {
        return @37;
    } else if ([VNBarcodeSymbologyITF14 isEqualToString:symbol]) {
        return @45;
    } else if ([VNBarcodeSymbologyPDF417 isEqualToString:symbol]) {
        return @57;
    } else if ([VNBarcodeSymbologyQR isEqualToString:symbol]) {
        return @64;
    } else if ([VNBarcodeSymbologyUPCE isEqualToString:symbol]) {
        return @9;
    }
    return nil;
}

@end
