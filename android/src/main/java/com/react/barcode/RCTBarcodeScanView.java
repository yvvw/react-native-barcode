package com.react.barcode;

import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Rect;
import android.os.AsyncTask;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.ViewGroup;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.google.android.cameraview.AspectRatio;
import com.google.android.cameraview.CameraView;
import com.google.android.cameraview.Size;
import com.react.barcode.decode.Result;
import com.react.barcode.decode.ZBarDecoder;

import java.util.List;

public class RCTBarcodeScanView extends CameraView implements LifecycleEventListener {
    private ThemedReactContext mContext;

    private boolean isSetupSuccess;

    private boolean mEnable;
    private boolean mGranted;
    private int[] mRawFormats;
    private Size mPreviewSize;
    private Size mScanSize;

    private ZBarDecoder mZBarDecoder;
    private DecodeTask mTask;
    private CameraView.Callback mCameraCallback = new CameraView.Callback() {
        @Override
        public void onFramePreview(CameraView cameraView, byte[] data,
                                   int width, int height, int orientation) {
            if (mTask != null && mTask.getStatus() != AsyncTask.Status.FINISHED) {
                return;
            }
            if (data.length < (1.5 * width * height)) {
                return;
            }
            if (mScanSize.getWidth() == 0 || mScanSize.getHeight() == 0) {
                return;
            }
            mTask = new DecodeTask(mZBarDecoder);
            try {
                Result result =
                        mTask.execute(data, width, height, mPreviewSize, mScanSize).get();
                onScan(result);
            } catch (Exception ignored) {
            }
        }
    };

    public RCTBarcodeScanView(@NonNull Context context) {
        this(context, null);
    }

    public RCTBarcodeScanView(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public RCTBarcodeScanView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mContext = (ThemedReactContext) context;
        setLayoutParams(
                new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT));
        setAspectRatio(AspectRatio.of(4, 3));
        setAdjustViewBounds(false);
    }

    private void validateAndSetup() {
        if (!deviceHasCamera()) {
            onError(Error.DEVICE_NO_CAMERA.getCode(), "Device no valid camera.");
            return;
        }
        if (mGranted) {
            setup();
        }
    }

    private void setup() {
        if (isSetupSuccess) return;

        mContext.addLifecycleEventListener(this);

        mZBarDecoder = new ZBarDecoder();
        mZBarDecoder.setFormat(mRawFormats);

        setFacing(FACING_BACK);
        setAspectRatio(AspectRatio.of(4, 3));
        addCallback(mCameraCallback);
        setScanning(mEnable);
        start();

        isSetupSuccess = true;
    }

    public void setEnable(boolean enable) {
        mEnable = enable;
        if (isSetupSuccess) {
            setScanning(mEnable);
        }
    }

    public void setGranted(boolean granted) {
        mGranted = granted;
        validateAndSetup();
    }

    public void setFlash(boolean flash) {
        setFlash(flash ? CameraView.FLASH_TORCH : CameraView.FLASH_OFF);
    }

    public void setFormats(int[] rawFormats) {
        mRawFormats = rawFormats;
        if (isSetupSuccess) {
            mZBarDecoder.setFormat(rawFormats);
        }
    }

    public void setPreviewSize(int left, int top, int right, int bottom) {
        Size previewSize = new Size(right - left, bottom - top);
        if (!previewSize.equals(mPreviewSize)) {
            mPreviewSize = previewSize;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
                setClipBounds(new Rect(left, top, right, bottom));
            }
            validateScanRect();
        }
    }

    public void setScanSize(Size size) {
        if (mScanSize == null || !mScanSize.equals(size)) {
            mScanSize = size;
            validateScanRect();
        }
    }

    private void validateScanRect() {
        if (mPreviewSize == null) return;

        int width = mScanSize.getWidth() >= 0 && mScanSize.getWidth() <= mPreviewSize.getWidth()
                ? mScanSize.getWidth()
                : mPreviewSize.getWidth();
        int height = mScanSize.getHeight() >= 0 && mScanSize.getHeight() <= mPreviewSize.getHeight()
                ? mScanSize.getHeight()
                : mPreviewSize.getHeight();
        mScanSize = new Size(width, height);
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);
        setPreviewSize(left, top, right, bottom);
        validateAndSetup();
    }

    private void onScan(Result result) {
        WritableMap event = Arguments.createMap();
        event.putInt("type", result.getRaw());
        event.putString("content", result.getContent());
        onEvent("onScan", event);
    }

    private void onError(String code, String message) {
        WritableMap event = Arguments.createMap();
        event.putString("code", code);
        event.putString("message", message);
        onEvent("onError", event);
    }

    private void onEvent(String eventName, @Nullable WritableMap event) {
        mContext.getJSModule(RCTEventEmitter.class).receiveEvent(getId(), eventName, event);
    }

    private boolean deviceHasCamera() {
        return mContext.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA);
    }

    @Override
    public void onHostResume() {
        start();
    }

    @Override
    public void onHostPause() {
        stop();
    }

    @Override
    public void onHostDestroy() {
        mZBarDecoder.release();
    }

    private static class DecodeTask extends AsyncTask<Object, Void, Result> {
        private final ZBarDecoder mZBarDecoder;

        DecodeTask(ZBarDecoder zbarDecoder) {
            mZBarDecoder = zbarDecoder;
        }

        @Override
        protected Result doInBackground(Object... objects) {
            byte[] data = (byte[]) objects[0];
            int imageWidth = (int) objects[1];
            int imageHeight = (int) objects[2];
            Size previewSize = (Size) objects[3];
            Size scanSize = (Size) objects[4];

            double ratio;
            if (imageWidth / previewSize.getHeight() > imageHeight / previewSize.getWidth()) {
                ratio = (double) imageHeight / previewSize.getWidth();
            } else {
                ratio = (double) imageWidth / previewSize.getHeight();
            }
            int left = (int) ((previewSize.getHeight() - scanSize.getHeight()) / 2 * ratio);
            int right = (int) (left + ratio * scanSize.getHeight());
            int bottom = (int) (imageHeight - (previewSize.getWidth() - scanSize.getWidth()) / 2 * ratio);
            int top = (int) (bottom - ratio * scanSize.getWidth());
            Rect scanRect = new Rect(left, top, right, bottom);

            List<Result> decodeResults = mZBarDecoder.decode(data, imageWidth, imageHeight, scanRect);
            if (decodeResults != null) {
                return decodeResults.get(0);
            }
            return null;
        }
    }
}
