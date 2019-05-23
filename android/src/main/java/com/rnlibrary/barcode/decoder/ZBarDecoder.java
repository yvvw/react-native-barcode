package com.rnlibrary.barcode.decoder;

import android.graphics.Bitmap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import net.sourceforge.zbar.Config;
import net.sourceforge.zbar.Image;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;
import net.sourceforge.zbar.SymbolSet;

import java.nio.charset.Charset;

public class ZBarDecoder implements Decoder {
    private final ImageScanner mScanner;

    public ZBarDecoder() {
        mScanner = new ImageScanner();
        mScanner.setConfig(0, Config.X_DENSITY, 2);
        mScanner.setConfig(0, Config.Y_DENSITY, 2);
    }

    @Override
    public void release() {
        mScanner.destroy();
    }

    @Override
    public void setFormats(ReadableArray formats) {
        if (formats.size() > 0) {
            // clear all formats
            mScanner.setConfig(Symbol.NONE, Config.ENABLE, 0);
            for (int i = 0; i < formats.size(); i++) {
                int format = formats.getInt(i);
                if (format != -1) {
                    mScanner.setConfig(formatToSymbol(format), Config.ENABLE, 1);
                }
            }
        } else {
            // set all formats
            mScanner.setConfig(Symbol.NONE, Config.ENABLE, 1);
        }
    }

    @Override
    public ReadableMap decodeRGBBitmap(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        int[] pixels = new int[width * height];
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height);
        bitmap.recycle();

        Image image = new Image(width, height, ImageFormat.RGB4.toString());
        image.setData(pixels);
        image = image.convert(ImageFormat.Y800.toString());

        WritableMap result = null;
        if (mScanner.scanImage(image) != 0) {
            SymbolSet symbols = mScanner.getResults();
            Symbol symbol = symbols.iterator().next();
            result = Arguments.createMap();
            result.putInt("format", symbolToFormat(symbol.getType()));
            result.putString("content", fixEncoding(symbol.getData()));
        }
        return result;
    }

    @Override
    public WritableMap decodeNV21Data(byte[] data, int width, int height, int rotation) {
        Image image = new Image(width, height, ImageFormat.Y800.toString());
        image.setData(data);

        WritableMap result = null;
        if (mScanner.scanImage(image) != 0) {
            SymbolSet symbols = mScanner.getResults();
            Symbol symbol = symbols.iterator().next();
            result = Arguments.createMap();
            result.putInt("format", symbolToFormat(symbol.getType()));
            result.putString("content", fixEncoding(symbol.getData()));
        }
        image.destroy();
        return result;
    }

    private static Charset ShiftJIS = Charset.forName("Shift_JIS");
    private static Charset UTF8 = Charset.forName("UTF-8");

    private static String fixEncoding(String content) {
        byte[] bytes = content.getBytes(ShiftJIS);
        if (content.equals(new String(bytes, ShiftJIS))) {
            return new String(bytes, UTF8);
        }
        return content;
    }

    private enum ImageFormat {
        RGB4("RGB4"),
        Y800("Y800");

        String f;

        ImageFormat(String f) {
            this.f = f;
        }

        @Override
        public String toString() {
            return f;
        }
    }

    private static int symbolToFormat(int symbol) {
        if (2 == symbol) { // Symbol.EAN2
            return 2;
        } else if (5 == symbol) { // Symbol.EAN5
            return 5;
        } else if (Symbol.EAN8 == symbol) {
            return 8;
        } else if (Symbol.UPCE == symbol) {
            return 9;
        } else if (Symbol.ISBN10 == symbol) {
            return 10;
        } else if (Symbol.UPCA == symbol) {
            return 12;
        } else if (Symbol.EAN13 == symbol) {
            return 13;
        } else if (Symbol.ISBN13 == symbol) {
            return 14;
        } else if (15 == symbol) { // Symbol.COMPOSITE
            return 15;
        } else if (Symbol.I25 == symbol) {
            return 25;
        } else if (Symbol.DATABAR == symbol) {
            return 34;
        } else if (Symbol.DATABAR_EXP == symbol) {
            return 35;
        } else if (Symbol.CODABAR == symbol) {
            return 38;
        } else if (Symbol.CODE39 == symbol) {
            return 39;
        } else if (Symbol.PDF417 == symbol) {
            return 57;
        } else if (Symbol.QRCODE == symbol) {
            return 64;
        } else if (Symbol.CODE93 == symbol) {
            return 93;
        } else if (Symbol.CODE128 == symbol) {
            return 128;
        }
        return -1;
    }

    private static int formatToSymbol(int format) {
        if (2 == format) {
            return 2; // Symbol.EAN2
        } else if (5 == format) {
            return 5; // Symbol.EAN5
        } else if (8 == format) {
            return Symbol.EAN8;
        } else if (9 == format) {
            return Symbol.UPCE;
        } else if (10 == format) {
            return Symbol.ISBN10;
        } else if (12 == format) {
            return Symbol.UPCA;
        } else if (13 == format) {
            return Symbol.EAN13;
        } else if (14 == format) {
            return Symbol.ISBN13;
        } else if (15 == format) {
            return 15; // Symbol.COMPOSITE
        } else if (25 == format) {
            return Symbol.I25;
        } else if (34 == format) {
            return Symbol.DATABAR;
        } else if (35 == format) {
            return Symbol.DATABAR_EXP;
        } else if (38 == format) {
            return Symbol.CODABAR;
        } else if (39 == format) {
            return Symbol.CODE39;
        } else if (57 == format) {
            return Symbol.PDF417;
        } else if (64 == format) {
            return Symbol.QRCODE;
        } else if (93 == format) {
            return Symbol.CODE93;
        } else if (128 == format) {
            return Symbol.CODE128;
        }
        return -1;
    }
}
