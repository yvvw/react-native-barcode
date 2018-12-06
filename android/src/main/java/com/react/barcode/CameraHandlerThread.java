package com.react.barcode;

import android.os.Handler;
import android.os.HandlerThread;

class CameraHandlerThread extends HandlerThread {
    private Handler mCameraHandler;

    CameraHandlerThread() {
        super(CameraHandlerThread.class.getSimpleName());
        start();
        mCameraHandler = new Handler(getLooper());
    }

    void asyncRun(Runnable start) {
        mCameraHandler.post(start);
    }
}
