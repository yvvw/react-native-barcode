package com.react.barcode.decode;

import android.graphics.Rect;
import android.support.annotation.NonNull;

import java.util.List;

import javax.annotation.Nullable;

interface Decoder {
    void setFormat(@NonNull int[] rawFormats);

    List<Result> decode(int[] pixels, int width, int height);

    List<Result> decode(byte[] data, int width, int height, Rect rect);
}
