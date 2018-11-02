package com.react.barcode.decode;

import android.graphics.Rect;
import android.support.annotation.NonNull;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.NotFoundException;
import com.google.zxing.PlanarYUVLuminanceSource;
import com.google.zxing.RGBLuminanceSource;
import com.google.zxing.common.GlobalHistogramBinarizer;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.multi.GenericMultipleBarcodeReader;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;

public class ZXingDecoder implements Decoder {
    private MultiFormatReader mReader;

    public ZXingDecoder() {
        mReader = new MultiFormatReader();
    }

    public void setFormat(@NonNull int[] rawFormats) {
        List<BarcodeFormat> formats = Format.getFormats(rawFormats);
        Map<DecodeHintType, Object> hints = new EnumMap<>(DecodeHintType.class);
        hints.put(DecodeHintType.POSSIBLE_FORMATS, formats);
        mReader.setHints(hints);
    }

    @Nullable
    public List<Result> decode(int[] pixels, int width, int height) {
        return decode(new RGBLuminanceSource(width, height, pixels));
    }

    @Nullable
    public List<Result> decode(byte[] data, int width, int height, Rect rect) {
        PlanarYUVLuminanceSource source = new PlanarYUVLuminanceSource(data, width, height,
                rect.left, rect.top, rect.width(), rect.height(), false);
        return decode(source);
    }

    @Nullable
    private List<Result> decode(LuminanceSource source) {
        BinaryBitmap bitmap = new BinaryBitmap(new GlobalHistogramBinarizer(source));

        com.google.zxing.Result[] decodeResults = null;
        GenericMultipleBarcodeReader multiReader = new GenericMultipleBarcodeReader(mReader);
        try {
            decodeResults = multiReader.decodeMultiple(bitmap);
        } catch (NotFoundException ignored) {
        }
        if (decodeResults == null) {
            bitmap = new BinaryBitmap(new HybridBinarizer(source.invert()));
            try {
                decodeResults = multiReader.decodeMultiple(bitmap);
            } catch (NotFoundException ignored) {
            }
        }
        if (decodeResults != null) {
            List<Result> results = new ArrayList<>();
            for (com.google.zxing.Result result : decodeResults) {
                results.add(new Result(
                        Format.getRawFormat(result.getBarcodeFormat()), result.getText()));
            }
            return results;
        } else return null;
    }

    public void release() {
        mReader.reset();
    }

    public enum Format {

        CODABAR(38, BarcodeFormat.CODABAR),

        CODE_39(39, BarcodeFormat.CODE_39),

        CODE_93(93, BarcodeFormat.CODE_93),

        CODE_128(128, BarcodeFormat.CODE_128),

        EAN_8(8, BarcodeFormat.EAN_8),

        EAN_13(8, BarcodeFormat.EAN_13),

        PDF_417(57, BarcodeFormat.PDF_417),

        QR_CODE(64, BarcodeFormat.QR_CODE),

        UPC_A(12, BarcodeFormat.UPC_A),

        UPC_E(9, BarcodeFormat.UPC_E),

        // custom raw value
        AZTEC(70, BarcodeFormat.AZTEC),

        DATA_MATRIX(71, BarcodeFormat.DATA_MATRIX),

        ITF(72, BarcodeFormat.ITF),

        MAXICODE(73, BarcodeFormat.MAXICODE),

        RSS_14(74, BarcodeFormat.RSS_14),

        RSS_EXPANDED(75, BarcodeFormat.RSS_EXPANDED),

        UPC_EAN_EXTENSION(76, BarcodeFormat.UPC_EAN_EXTENSION);


        private int raw;
        private BarcodeFormat format;

        Format(int raw, BarcodeFormat format) {
            this.raw = raw;
            this.format = format;
        }

        public static int getRawFormat(BarcodeFormat format) {
            for (Format rawFormat : Format.values()) {
                if (rawFormat.format == format) {
                    return rawFormat.raw;
                }
            }
            return -1;
        }

        public static BarcodeFormat getFormat(int rawFormat) {
            for (Format mFormat : Format.values()) {
                if (mFormat.raw == rawFormat) {
                    return mFormat.format;
                }
            }
            return null;
        }

        public static List<BarcodeFormat> getFormats(int[] rawFormats) {
            List<BarcodeFormat> formats = new ArrayList<>();
            for (int rawFormat : rawFormats) {
                BarcodeFormat format = getFormat(rawFormat);
                if (format != null) {
                    formats.add(format);
                }
            }
            return formats;
        }
    }
}
