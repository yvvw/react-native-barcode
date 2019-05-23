package com.rnlibrary.barcode;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.WorkerThread;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.PermissionAwareActivity;
import com.facebook.react.modules.core.PermissionListener;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.otaliastudios.cameraview.Audio;
import com.otaliastudios.cameraview.CameraException;
import com.otaliastudios.cameraview.CameraListener;
import com.otaliastudios.cameraview.CameraView;
import com.otaliastudios.cameraview.Flash;
import com.otaliastudios.cameraview.Frame;
import com.otaliastudios.cameraview.FrameProcessor;
import com.otaliastudios.cameraview.Gesture;
import com.otaliastudios.cameraview.GestureAction;
import com.otaliastudios.cameraview.Size;
import com.rnlibrary.barcode.decoder.Decoder;
import com.rnlibrary.barcode.decoder.ZBarDecoder;
import com.rnlibrary.barcode.decoder.ZXingDecoder;

public class RNLBarCodeScannerView extends CameraView implements LifecycleEventListener, PermissionListener {
    private ThemedReactContext mContext;

    public RNLBarCodeScannerView(ThemedReactContext context) {
        super(context.getApplicationContext());
        mContext = context;
        setAudio(Audio.OFF);
        mapGesture(Gesture.PINCH, GestureAction.ZOOM);
        mapGesture(Gesture.TAP, GestureAction.FOCUS);
        mContext.addLifecycleEventListener(this);
        addCameraListener(mCameraListener);
        mContext.runOnNativeModulesQueueThread(new Runnable() {
            @Override
            public void run() {
                setup();
            }
        });
    }

    private static final String mCameraPermission = Manifest.permission.CAMERA;

    public void setup() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (mContext.checkSelfPermission(mCameraPermission) != PackageManager.PERMISSION_GRANTED) {
                PermissionAwareActivity activity = (PermissionAwareActivity) mContext.getCurrentActivity();
                if (activity != null) {
                    activity.requestPermissions(new String[]{mCameraPermission}, PERMISSION_REQUEST_CODE, this);
                    return;
                }
                errorCallback(RNLBarCodeError.NoCameraPermission.getCode(),
                        "Don't authorize use camera");
                return;
            }
        }
        open();
        if (!this.enable) {
            addFrameProcessor(mFrameProcessor);
        }
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (PERMISSION_REQUEST_CODE == requestCode &&
                permissions.length == 1 &&
                permissions[0].equals(mCameraPermission) &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            mContext.runOnNativeModulesQueueThread(new Runnable() {
                @Override
                public void run() {
                    setup();
                }
            });
        } else {
            errorCallback(RNLBarCodeError.NoCameraPermission.getCode(),
                    "Don't authorize use camera");
        }
        return true;
    }

    public void release() {
        mContext.removeLifecycleEventListener(this);
        mContext.runOnNativeModulesQueueThread(new Runnable() {
            @Override
            public void run() {
                destroy();
                if (decoder != null) {
                    decoder.release();
                }
            }
        });
    }

    private CameraListener mCameraListener = new CameraListener() {
        @Override
        public void onCameraError(@NonNull final CameraException exception) {
            super.onCameraError(exception);
            final int reason = exception.getReason();
            mContext.runOnNativeModulesQueueThread(new Runnable() {
                @Override
                public void run() {
                    Integer code = RNLBarCodeError.InvokeFailed.getCode();
                    if (reason == CameraException.REASON_NO_CAMERA) {
                        code = RNLBarCodeError.NoCameraDevice.getCode();
                    }
                    errorCallback(code, exception.getMessage());
                }
            });
        }
    };

    private static final int FRAME_THROTTLE_COUNT = 10;
    private int frameCount = 0;
    private boolean isDecoding = false;

    private WritableMap decodeFrame(Frame frame) {
        Size size = frame.getSize();
        return decoder.decodeNV21Data(
                frame.getData(), size.getWidth(), size.getHeight(), frame.getRotation());
    }

    public FrameProcessor mFrameProcessor = new FrameProcessor() {
        @Override
        @WorkerThread
        public void process(@NonNull Frame frame) {
            if (!enable || isDecoding || decoder == null) {
                return;
            }
            if (frameCount-- == 0) {
                frameCount = FRAME_THROTTLE_COUNT;
                isDecoding = true;
                final WritableMap result = decodeFrame(frame);
                if (result != null) {
                    mContext.runOnNativeModulesQueueThread(new Runnable() {
                        @Override
                        public void run() {
                            resultCallback(result);
                        }
                    });
                }
                isDecoding = false;
            }
        }
    };

    private boolean enable;

    public void setEnable(boolean enable) {
        if (enable && !this.enable) {
            frameCount = 0;
            addFrameProcessor(mFrameProcessor);
        } else if (!enable && this.enable) {
            clearFrameProcessors();
        }
        this.enable = enable;
    }

    private int decoderID = -1;
    private Decoder decoder = null;

    public void setDecoder(int decoderID) {
        if (decoderID == 2 || decoderID == 0) {
            // ZBar Auto
            if (this.decoderID != 2 && this.decoderID != 0) {
                if (this.decoder != null) {
                    this.decoder.release();
                }
                this.decoder = new ZBarDecoder();
                setFormats(this.formats);
            }
        } else if (decoderID == 1 && this.decoderID != 1) {
            // ZXing
            if (this.decoder != null) {
                this.decoder.release();
            }
            this.decoder = new ZXingDecoder();
            setFormats(this.formats);
        } else {
            if (this.decoder != null) {
                removeFrameProcessor(mFrameProcessor);
                this.decoder.release();
                this.decoder = null;
            }
            errorCallback(RNLBarCodeError.InvokeFailed.getCode(),
                    "Device doesn't support this decoder");
        }
        if (this.decoder != null && this.enable) {
            addFrameProcessor(mFrameProcessor);
        }
        this.decoderID = decoderID;
    }

    private ReadableArray formats = null;

    public void setFormats(ReadableArray formats) {
        if (this.decoder != null && formats != null) {
            this.decoder.setFormats(formats);
        }
        this.formats = formats;
    }

    private int torchMode = -1;

    public void setTorch(int torchMode) {
        if (torchMode == 0 && this.torchMode != 0) {
            this.torchMode = torchMode;
            setFlash(Flash.OFF);
        } else if (torchMode == 1 && this.torchMode != 1) {
            this.torchMode = torchMode;
            setFlash(Flash.TORCH);
        } else if (torchMode == 2 && this.torchMode != 2) {
            this.torchMode = torchMode;
            setFlash(Flash.AUTO);
        }
        this.torchMode = torchMode;
    }

    public void resultCallback(WritableMap result) {
        callback("onResult", result);
    }

    public void errorCallback(int code, String message) {
        WritableMap error = Arguments.createMap();
        error.putInt("code", code);
        error.putString("message", message);
        callback("onError", error);
    }

    private void callback(String name, WritableMap event) {
        mContext.getJSModule(RCTEventEmitter.class)
                .receiveEvent(getId(), name, event);
    }

    @Override
    public void onHostResume() {
        open();
    }

    @Override
    public void onHostPause() {
        close();
    }

    @Override
    public void onHostDestroy() {
        release();
    }
}
