#import "RNLBarCodeModule.h"
#import "RNLBarCodeDecoder.h"
#import "RNLBarCodeUtils.h"
#import "RNLBarCodeScannerView.h"

#import <AVFoundation/AVFoundation.h>

#import <React/RCTConvert.h>
#import <React/RCTUtils.h>

@interface RNLBarCodeScannerView ()

@property (nonatomic, retain) AVCaptureDeviceInput *input;

@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, retain) RNLBarCodeDecoderAV *decoder;

@property (nonatomic, assign) BOOL initializeSuccess;

@end

@implementation RNLBarCodeScannerView

@synthesize manager = _manager;
@synthesize input = _input;
@synthesize previewLayer = _previewLayer;
@synthesize decoderID = _decoderID;
@synthesize decoder = _decoder;
@synthesize initializeSuccess = _initializeSuccess;
@synthesize enable = _enable;
@synthesize formats = _formats;
@synthesize torch = _torch;
@synthesize onResult = _onResult;
@synthesize onError = _onError;

- (void)dealloc
{
    [_manager.session removeInput:_input];
    [_manager.session removeOutput:_decoder.output];
    if (_manager.session.isRunning) {
        [_manager.session stopRunning];        
    }
}

- (void)didSetProps:(NSArray<NSString *> *)changedProps
{
    dispatch_async(_manager.methodQueue, ^{
        [self refresh];
    });
}

- (void)refresh
{
    if (!_initializeSuccess) {
        static BOOL hasCameraPermission;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            AVAuthorizationStatus permission = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (AVAuthorizationStatusAuthorized == permission) {
                hasCameraPermission = YES;
            } else if (AVAuthorizationStatusNotDetermined == permission) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        hasCameraPermission = YES;
                        dispatch_async(self->_manager.methodQueue, ^{
                            [self refresh];
                        });
                    }
                }];
                return;
            }
        });
        if (!hasCameraPermission) {
            [self errorCallbackWithCode:RNLBarCodeNoCameraPermission
                             andMessage:@"Don't authorize use camera"];
            return;
        }
        if (_manager.device == nil) {
            [self errorCallbackWithCode:RNLBarCodeNoCameraDevice
                             andMessage:@"Device doesn't have available camera"];
            return;
        }
        if (_previewLayer == nil) {
            _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_manager.session];
            CGSize screenSize = RCTScreenSize();
            _previewLayer.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
            [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        }
        if (_input == nil) {
            NSError *error;
            _input = [AVCaptureDeviceInput deviceInputWithDevice:_manager.device error:&error];
            if (_input == nil) {
                [self errorCallbackWithCode:RNLBarCodeInvokeFailedError
                                 andMessage:[NSString stringWithFormat:@"Instance iOS AVCaptureDeviceInput failed, reason %@", error]];
                return;
            }
        }
        if ([_manager.session canAddInput:_input]) {
            [_manager.session addInput:_input];
        } else {
            [self errorCallbackWithCode:RNLBarCodeInvokeFailedError
                             andMessage:@"IOS AVCaptureSession can't add AVCaptureDeviceInput"];
            return;
        }
        _initializeSuccess = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.layer insertSublayer:self->_previewLayer atIndex:0];
        });
        if (!_manager.session.isRunning) {
            [_manager.session startRunning];
        }
    }
    // view props update
    if ([_decoderID isEqualToNumber:@4] || [_decoderID isEqualToNumber:@0]) {
        // AVFoundation or Auto
        if (_decoder == nil) {
            _decoder = [RNLBarCodeDecoderAV new];
        }
    } else {
        [self errorCallbackWithCode:RNLBarCodeInvokeFailedError
                         andMessage:@"Device doesn't support this decoder"];
        return;
    }
    if (_enable) {
        if (![_manager.session.outputs containsObject:_decoder.output]) {
            if ([_manager.session canAddOutput:_decoder.output]) {
                [_manager.session addOutput:_decoder.output];
            } else {
                [self errorCallbackWithCode:RNLBarCodeInvokeFailedError
                                 andMessage:@"IOS AVCaptureSession can't add AVCaptureMetadataOutput"];
                return;
            }
        }
    } else {
        if ([_manager.session.outputs containsObject:_decoder.output]) {
            [_manager.session removeOutput:_decoder.output];
        }
    }
    if (_enable && [_manager.session.outputs containsObject:_decoder.output]) {
        [_decoder setFormats:_formats];
        __weak RNLBarCodeScannerView *weakSelf = self;
        [_decoder startDecodeWithQueue:_manager.methodQueue andResultCallback:^(NSDictionary * _Nonnull result) {
            if (weakSelf.onResult) weakSelf.onResult(result);
        }];
    }
    BOOL isLocked = NO;
    if (AVCaptureTorchModeOn == _torch.integerValue) {
        if (_manager.device.torchMode != AVCaptureTorchModeOn &&
            _manager.device.torchAvailable &&
            [_manager.device isTorchModeSupported:AVCaptureTorchModeOn]) {
            if (!isLocked) {
                isLocked = [_manager.device lockForConfiguration:nil];
            }
            if (isLocked) {
                _manager.device.torchMode = AVCaptureTorchModeOn;
            }
        }
    } else if (AVCaptureTorchModeAuto == _torch.integerValue) {
        if (_manager.device.torchMode != AVCaptureTorchModeAuto &&
            _manager.device.torchAvailable &&
            [_manager.device isTorchModeSupported:AVCaptureTorchModeAuto]) {
            if (!isLocked) {
                isLocked = [_manager.device lockForConfiguration:nil];
            }
            if (isLocked) {
                _manager.device.torchMode = AVCaptureTorchModeAuto;
            }
        }
    } else if (AVCaptureTorchModeOff == _torch.integerValue) {
        if (_manager.device.torchMode != AVCaptureTorchModeOff &&
            _manager.device.torchAvailable &&
            [_manager.device isTorchModeSupported:AVCaptureTorchModeOff]) {
            if (!isLocked) {
                isLocked = [_manager.device lockForConfiguration:nil];
            }
            if (isLocked) {
                _manager.device.torchMode = AVCaptureTorchModeOff;
            }
        }
    }
    if (isLocked) {
        [_manager.device unlockForConfiguration];
    }
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  if (_previewLayer != nil) {
    _previewLayer.frame = CGRectMake(
                              -self.layer.frame.origin.x,
                              -self.layer.frame.origin.y,
                              _previewLayer.frame.size.width,
                              _previewLayer.frame.size.height);
  }
}

- (void)errorCallbackWithCode:(NSInteger)code andMessage:(NSString *)message
{
    if (_onError) {
        _onError(@{
                   @"code": [NSNumber numberWithInteger:code],
                   @"message": message,
                   });
    }
}

@end
