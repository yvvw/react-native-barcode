package com.rnlibrary.barcode.decoder;

import android.graphics.Bitmap;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

public interface Decoder {
    void setFormats(ReadableArray formats);

    ReadableMap decodeRGBBitmap(Bitmap bitmap);

    WritableMap decodeNV21Data(byte[] data, int width, int height, int rotation);

    void release();
}
