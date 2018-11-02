package com.react.barcode;

import android.Manifest;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.react.barcode.decode.Result;
import com.react.barcode.decode.ZBarDecoder;
import com.react.barcode.decode.ZXingDecoder;
import com.react.barcode.utils.ImageUtil;
import com.react.barcode.utils.PermissionUtil;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

public class RCTBarcodeModule extends ReactContextBaseJavaModule {
    private static ReactApplicationContext mReactContext;

    RCTBarcodeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RCTBarcode";
    }

    @ReactMethod
    public void base64(String input, ReadableArray formats, Promise promise) {
        Bitmap image = null;
        try {
            byte[] data = Base64.decode(input, Base64.NO_WRAP);
            image = ImageUtil.bytes2Bitmap(data);
        } catch (Exception ignored) {
        }
        if (image == null) {
            promise.reject(Error.DECODE_FAILED.getCode(), "Decode image data failed.");
            return;
        }

        decode(image, formats, promise);
    }

    @ReactMethod
    public void image(String imageUri, ReadableArray formats, Promise promise) {
        Bitmap image = null;
        if (imageUri.indexOf("/") == 0) {
            if (PermissionUtil.isGranted(mReactContext, Manifest.permission.READ_EXTERNAL_STORAGE)) {
                image = BitmapFactory.decodeFile(imageUri);
            } else {
                promise.reject(Error.NOT_GRANT_READ_IMAGE.getCode(), "User no authorize read extra storage image.");
                return;
            }
        }
        if (image == null) {
            try {
                URL url = new URL(imageUri);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setDoInput(true);
                connection.connect();
                InputStream input = connection.getInputStream();
                image = BitmapFactory.decodeStream(input);
                input.close();
                connection.disconnect();
            } catch (Exception ignored) {
            }
        }
        if (image == null) {
            promise.reject(Error.FILE_NOT_FOUND.getCode(), "File not found.");
            return;
        }

        decode(image, formats, promise);
    }

    @ReactMethod
    public void screenshot(ReadableArray formats, Promise promise) {
        Bitmap screenshot = null;
        try {
            View window = getCurrentActivity().getWindow().getDecorView().getRootView();
            window.setDrawingCacheEnabled(true);
            screenshot = Bitmap.createBitmap(window.getDrawingCache());
            window.setDrawingCacheEnabled(false);
        } catch (Exception ignored) {
        }
        if (screenshot == null) {
            promise.reject(Error.DECODE_FAILED.getCode(), "Take screenshot failed.");
            return;
        }

        decode(screenshot, formats, promise);
    }

    private void decode(Bitmap image, ReadableArray formats, Promise promise) {
        image = ImageUtil.compressBySampleSize(image, 600, 600);
        if (image == null) {
            promise.reject(Error.DECODE_FAILED.getCode(), "Image compress failed.");
            return;
        }

        ZBarDecoder zBarDecoder = new ZBarDecoder();
        int[] rawFormats = new int[formats.size()];
        for (int i = 0; i < formats.size(); i++) {
            rawFormats[i] = formats.getInt(i);
        }
        zBarDecoder.setFormat(rawFormats);

        int width = image.getWidth();
        int height = image.getHeight();
        int[] pixels = new int[width * height];
        image.getPixels(pixels, 0, width, 0, 0, width, height);

        List<Result> decodeResults = zBarDecoder.decode(pixels, width, height);
        zBarDecoder.release();
        if (decodeResults == null || decodeResults.size() == 0) {
            ZXingDecoder zXingDecoder = new ZXingDecoder();
            zXingDecoder.setFormat(rawFormats);
            decodeResults = zXingDecoder.decode(pixels, width, height);
            zXingDecoder.release();
        }
        if (decodeResults != null) {
            WritableMap result = Arguments.createMap();
            for (Result decodeResult : decodeResults) {
                result.putInt(Result.Type, decodeResult.getRaw());
                result.putString(Result.Content, decodeResult.getContent());
            }
            promise.resolve(result);
        } else {
            promise.reject(Error.BARCODE_NOT_FOUND.getCode(), "Barcode not found.");
        }
    }
}
