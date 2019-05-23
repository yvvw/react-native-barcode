package com.rnlibrary.barcode.decoder;

import android.graphics.Bitmap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.NotFoundException;
import com.google.zxing.PlanarYUVLuminanceSource;
import com.google.zxing.RGBLuminanceSource;
import com.google.zxing.Result;
import com.google.zxing.common.HybridBinarizer;
import com.rnlibrary.barcode.RNLBarCodeUtils;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

public class ZXingDecoder implements Decoder {
    private final MultiFormatReader mReader;
    private final Map<DecodeHintType, Object> mHints;
    private final List<BarcodeFormat> mSymbols;

    public ZXingDecoder() {
        mReader = new MultiFormatReader();
        mHints = new EnumMap<>(DecodeHintType.class);
        mHints.put(DecodeHintType.TRY_HARDER, Void.class);
        mSymbols = new ArrayList<>();
    }

    @Override
    public void release() {
        // Do nothing
    }

    @Override
    public void setFormats(ReadableArray formats) {
        mSymbols.clear();
        if (formats.size() > 0) {
            for (int i = 0; i < formats.size(); i++) {
                int format = formats.getInt(i);
                if (format != -1) {
                    mSymbols.add(formatToSymbol(format));
                }
            }
            mHints.put(DecodeHintType.POSSIBLE_FORMATS, mSymbols);
        } else {
            mHints.remove(DecodeHintType.POSSIBLE_FORMATS);
        }
    }

    @Override
    public ReadableMap decodeRGBBitmap(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        int[] pixels = new int[width * height];
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height);
        bitmap.recycle();

        RGBLuminanceSource source = new RGBLuminanceSource(width, height, pixels);
        BinaryBitmap bBitmap = new BinaryBitmap(new HybridBinarizer(source));
        WritableMap result = null;
        try {
            Result decodeResult = mReader.decode(bBitmap, mHints);
            result = Arguments.createMap();
            result.putInt("format", symbolToFormat(decodeResult.getBarcodeFormat()));
            result.putString("content", decodeResult.getText());
        } catch (NotFoundException ignored) {
        }
        return result;
    }

    @Override
    public WritableMap decodeNV21Data(byte[] data, int width, int height, int rotation) {
        byte[] yuv;
        int temp;
        switch (rotation) {
            case 90:
                yuv = RNLBarCodeUtils.rotateYUV90(data, width, height);
                temp = width;
                width = height;
                height = temp;
                break;
            case 180:
                yuv = RNLBarCodeUtils.rotateYUV180(data, width, height);
                break;
            case 270:
                yuv = RNLBarCodeUtils.rotateYUV270(data, width, height);
                temp = width;
                width = height;
                height = temp;
                break;
            default:
                yuv = data;
        }
        PlanarYUVLuminanceSource source = new PlanarYUVLuminanceSource(
                yuv, width, height, 0, 0, width, height, false);
        BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));
        WritableMap result = null;
        try {
            Result decodeResult = mReader.decode(bitmap, mHints);
            result = Arguments.createMap();
            result.putInt("format", symbolToFormat(decodeResult.getBarcodeFormat()));
            result.putString("content", decodeResult.getText());
        } catch (NotFoundException ignored) {
        }
        return result;
    }

    private static int symbolToFormat(BarcodeFormat symbol) {
        if (BarcodeFormat.AZTEC == symbol) {
            return 225;
        } else if (BarcodeFormat.CODABAR == symbol) {
            return 38;
        } else if (BarcodeFormat.CODE_128 == symbol) {
            return 128;
        } else if (BarcodeFormat.CODE_39 == symbol) {
            return 39;
        } else if (BarcodeFormat.CODE_93 == symbol) {
            return 93;
        } else if (BarcodeFormat.DATA_MATRIX == symbol) {
            return 200;
        } else if (BarcodeFormat.EAN_13 == symbol) {
            return 13;
        } else if (BarcodeFormat.EAN_8 == symbol) {
            return 8;
        } else if (BarcodeFormat.ITF == symbol) {
            return 25;
        } else if (BarcodeFormat.MAXICODE == symbol) {
            return 94;
        } else if (BarcodeFormat.PDF_417 == symbol) {
            return 57;
        } else if (BarcodeFormat.QR_CODE == symbol) {
            return 64;
        } else if (BarcodeFormat.RSS_14 == symbol) {
            return 34;
        } else if (BarcodeFormat.RSS_EXPANDED == symbol) {
            return 35;
        } else if (BarcodeFormat.UPC_A == symbol) {
            return 12;
        } else if (BarcodeFormat.UPC_E == symbol) {
            return 9;
        } else if (BarcodeFormat.UPC_EAN_EXTENSION == symbol) {
            return 15;
        }
        return -1;
    }

    private static BarcodeFormat formatToSymbol(int format) {
        if (225 == format) {
            return BarcodeFormat.AZTEC;
        } else if (38 == format) {
            return BarcodeFormat.CODABAR;
        } else if (128 == format) {
            return BarcodeFormat.CODE_128;
        } else if (39 == format) {
            return BarcodeFormat.CODE_39;
        } else if (93 == format) {
            return BarcodeFormat.CODE_93;
        } else if (200 == format) {
            return BarcodeFormat.DATA_MATRIX;
        } else if (13 == format) {
            return BarcodeFormat.EAN_13;
        } else if (8 == format) {
            return BarcodeFormat.EAN_8;
        } else if (25 == format) {
            return BarcodeFormat.ITF;
        } else if (94 == format) {
            return BarcodeFormat.MAXICODE;
        } else if (57 == format) {
            return BarcodeFormat.PDF_417;
        } else if (64 == format) {
            return BarcodeFormat.QR_CODE;
        } else if (34 == format) {
            return BarcodeFormat.RSS_14;
        } else if (35 == format) {
            return BarcodeFormat.RSS_EXPANDED;
        } else if (12 == format) {
            return BarcodeFormat.UPC_A;
        } else if (9 == format) {
            return BarcodeFormat.UPC_E;
        } else if (15 == format) {
            return BarcodeFormat.UPC_EAN_EXTENSION;
        }
        return null;
    }
}
