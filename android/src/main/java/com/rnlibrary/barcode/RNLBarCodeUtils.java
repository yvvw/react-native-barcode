package com.rnlibrary.barcode;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.util.Base64;
import android.view.View;

import com.rnlibrary.barcode.decoder.Decoder;
import com.rnlibrary.barcode.decoder.ZBarDecoder;
import com.rnlibrary.barcode.decoder.ZXingDecoder;

import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import javax.annotation.Nullable;

public final class RNLBarCodeUtils {
    @Nullable
    public static Decoder getDecoderByID(int id) {
        Decoder decoder = null;
        if (id == 2 || id == 0) {
            // ZBar Auto
            decoder = new ZBarDecoder();
        } else if (id == 1) {
            // ZXing
            decoder = new ZXingDecoder();
        }
        return decoder;
    }

    @Nullable
    public static Bitmap takeScreenshot(Activity activity) {
        try {
            View windowView = activity.getWindow().getDecorView().getRootView();
            Bitmap screenshot = Bitmap.createBitmap(
                    windowView.getWidth(), windowView.getHeight(), Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(screenshot);
            windowView.draw(canvas);
            return screenshot;
        } catch (Exception ignore) {

        }
        return null;
    }

    @Nullable
    public static Bitmap parseImageStr(String str) throws Exception {
        if (str.startsWith("/")) {
            str = "file://" + str;
        }

        Bitmap image;

        if (str.startsWith("file") || str.startsWith("http")) {
            InputStream iStream = null;
            try {
                if (str.startsWith("file")) {
                    iStream = new FileInputStream(str);
                } else if (str.startsWith("http")) {
                    URL url = new URL(str);
                    URLConnection connection = url.openConnection();
                    connection.connect();
                    iStream = connection.getInputStream();
                }
                image = BitmapFactory.decodeStream(iStream);
            } finally {
                if (iStream != null) {
                    iStream.close();
                }
            }
        } else {
            // maybe base64 encoding string
            if (str.startsWith("data:")) {
                str = str.substring(str.indexOf(",") + 1);
            }
            byte[] bytes = Base64.decode(str, Base64.DEFAULT);
            image = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
        }

        return image;
    }

    // https://stackoverflow.com/a/39800979/6428205
    public static byte[] rotateYUV90(byte[] data, int w, int h) {
        byte[] yuv = new byte[w * h * 3 / 2];
        int i = 0;
        for (int x = 0; x < w; x++) {
            for (int y = h - 1; y >= 0; y--) {
                yuv[i++] = data[y * w + x];
            }
        }
        i = w * h * 3 / 2 - 1;
        for (int x = w - 1; x > 0; x = x - 2) {
            for (int y = 0; y < h / 2; y++) {
                yuv[i--] = data[(w * h) + (y * w) + x];
                yuv[i--] = data[(w * h) + (y * w) + (x - 1)];
            }
        }
        return yuv;
    }

    public static byte[] rotateYUV180(byte[] data, int w, int h) {
        byte[] yuv = new byte[w * h * 3 / 2];
        int i;
        int count = 0;
        for (i = w * h - 1; i >= 0; i--) {
            yuv[count++] = data[i];
        }
        for (i = w * h * 3 / 2 - 1; i >= w * h; i -= 2) {
            yuv[count++] = data[i - 1];
            yuv[count++] = data[i];
        }
        return yuv;
    }

    public static byte[] rotateYUV270(byte[] data, int w, int h) {
        return rotateYUV180(rotateYUV90(data, w, h), w, h);
    }
}
