#import "RCTBarcodeScanView.h"

/**
 * 执行顺序 preview -> session start -> device
 */

@implementation RCTBarcodeScanView {
    AVCaptureDevice *_device;
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    BOOL _isSetupSuccess;
    CGSize _previewSize;
    CGSize _scanSize;
}

@synthesize enable = _enable;
@synthesize flash = _flash;
@synthesize autoFocus = _autoFocus;
@synthesize formats = _formats;
@synthesize scanSize = _scanSize;

- (void)dealloc
{
    if (_session) {
        [_session stopRunning];
    }
}

- (void)validateAndSetup
{
    if (![self deviceHasBackCamera]) {
        _onError(@{
                   @"code": ERROR_CODE(DEVICE_NO_CAMERA),
                   @"message": @"Device no valid camera."
                   });
        return;
    }
    [self checkCameraPermission:^(BOOL granted) {
        if (granted) {
            [self setup];
        } else {
            _onError(@{
                       @"code": ERROR_CODE(NOT_GRANT_USE_CAMERA),
                       @"message": @"User no authorize use camera."
                       });
        }
    }];
}

- (void)setup
{
    if (_isSetupSuccess) return;

    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:_input]) [_session addInput:_input];
    if ([_session canAddOutput:_output]) [_session addOutput:_output];
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    _output.metadataObjectTypes = _enable ? _formats : nil;
    [self updatePreviewFrame];

    [_session startRunning];
    [self updateScanFrame];
    [self updateConfigurate];

    _isSetupSuccess = true;
}

- (BOOL)updatePreviewFrame
{
    CGSize previewSize = self.frame.size;
    if (
        _previewSize.width != previewSize.width ||
        _previewSize.height != previewSize.height
        ) {
        _previewSize = previewSize;
        CGRect previewFrame = CGRectMake(0, 0, _previewSize.width, _previewSize.height);
        _previewLayer.frame = previewFrame;
         [self.layer insertSublayer:_previewLayer atIndex:0];
        return YES;
    }
    return NO;
}

- (void)updateScanFrame
{
    CGFloat scanWidth = _scanSize.width >= 0 ? _scanSize.width : _previewSize.width;
    CGFloat scanHeight = _scanSize.height >= 0 ? _scanSize.height : _previewSize.height;
    if (scanWidth > _previewSize.width) {
        scanWidth = _previewSize.width;
    }
    if (scanHeight > _previewSize.height) {
        scanHeight = _previewSize.height;
    }
    CGFloat x = (_previewSize.width - scanWidth) / 2;
    CGFloat y = (_previewSize.height - scanHeight) / 2;
    CGRect scanRect = CGRectMake(x, y, scanWidth, scanHeight);
    _output.rectOfInterest = [_previewLayer metadataOutputRectOfInterestForRect:scanRect];
}

- (void)updateConfigurate
{
    [_device lockForConfiguration:nil];
    if ([_device hasTorch]) {
        [_device setTorchMode:_flash ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    }
    if (_device.isAutoFocusRangeRestrictionSupported && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [_device setFocusMode:_autoFocus ? AVCaptureFocusModeContinuousAutoFocus : AVCaptureFocusModeAutoFocus];
    }
    [_device unlockForConfiguration];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self validateAndSetup];
    if (_isSetupSuccess) {
        BOOL updateSuccess = [self updatePreviewFrame];
        if (updateSuccess) {
            [_session stopRunning];
            [_session startRunning];
            [self updateScanFrame];
            [self updateConfigurate];
        }
    }
}

- (void)setEnable:(BOOL)enable
{
    if (_enable != enable) {
        _enable = enable;
        if (_isSetupSuccess) {
            _output.metadataObjectTypes = _enable ? _formats : nil;
        }
    }
}

- (void)setScanSize:(CGSize)scanSize
{
    if (_scanSize.width != scanSize.width || _scanSize.height != scanSize.height) {
        _scanSize = scanSize;
        if (_isSetupSuccess) {
            [self updateScanFrame];
            [self updateConfigurate];
        }
    }
}

- (void)setFormats:(NSArray<NSNumber *> *)rawFormats
{
    NSArray<AVMetadataObjectType> *formats = [AVFormat getFormatsFromRawFormats:rawFormats];
    _formats = formats;
    if (_isSetupSuccess) {
        _output.metadataObjectTypes = _enable ? _formats : nil;
    }
}

- (void)setFlash:(BOOL)flash
{
    if (_flash != flash) {
        _flash = flash;
        if (_isSetupSuccess) [self updateConfigurate];
    }
}

- (void)setAutoFocus:(BOOL)autoFocus
{
    if (_autoFocus != autoFocus) {
        _autoFocus = autoFocus;
        if (_isSetupSuccess) [self updateConfigurate];
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *object in metadataObjects) {
        if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSNumber *type = [AVFormat getRawFromFormat:object.type];
            NSString *content = [(AVMetadataMachineReadableCodeObject *) object stringValue];
            _onScan(@{ @"type": type, @"content": content });
        }
    }
}

- (BOOL)deviceHasBackCamera
{
    NSArray<AVCaptureDevice *> *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo] && [device position] == AVCaptureDevicePositionBack) {
            return YES;
        }
    }
    return NO;
}

- (void)checkCameraPermission:(void (^)(BOOL isAuthorized))nextStep
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            nextStep(YES);
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            nextStep(NO);
            break;
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                nextStep(granted);
            }];
    }
}

@end
