package com.rnlibrary.barcode;

import android.graphics.Bitmap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.rnlibrary.barcode.decoder.Decoder;

public class RNLBarCodeModule extends ReactContextBaseJavaModule {
    private static final String ModuleName = "RNLBarCode";

    RNLBarCodeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return ModuleName;
    }

    @ReactMethod
    public void decode(ReadableMap option, final Promise promise) {
        int decoderID = option.getInt("decoder");
        Decoder decoder = RNLBarCodeUtils.getDecoderByID(decoderID);
        if (decoder == null) {
            promise.reject(RNLBarCodeError.InvokeFailed.toString(),
                    "Device doesn't support this decoder");
            return;
        }
        decoder.setFormats(option.getArray("formats"));
        Bitmap image = null;
        if (option.getBoolean("screenshot")) {
            image = RNLBarCodeUtils.takeScreenshot(getCurrentActivity());
            if (image == null) {
                promise.reject(RNLBarCodeError.InvokeFailed.toString(),
                        "Can't take screenshot");
            }
        } else {
            try {
                image = RNLBarCodeUtils.parseImageStr(option.getString("data"));
            } catch (Exception e) {
                promise.reject(RNLBarCodeError.InvokeFailed.toString(),
                        "Parse image failed, reason: " + e.getMessage());
            }
        }
        if (image != null) {
            promise.resolve(decoder.decodeRGBBitmap(image));
        }
        decoder.release();
    }
}
