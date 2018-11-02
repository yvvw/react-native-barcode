package com.react.barcode.decode;

import android.graphics.Rect;
import android.support.annotation.NonNull;

import net.sourceforge.zbar.Config;
import net.sourceforge.zbar.Image;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;
import net.sourceforge.zbar.SymbolSet;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nullable;

public class ZBarDecoder implements Decoder {
    private ImageScanner mScanner;
    private List<Integer> mFormats;

    public ZBarDecoder() {
        mScanner = new ImageScanner();
        mScanner.setConfig(0, Config.X_DENSITY, 2);
        mScanner.setConfig(0, Config.Y_DENSITY, 2);
        mScanner.setConfig(Symbol.NONE, Config.ENABLE, 0);
    }

    public void setFormat(@NonNull int[] rawFormats) {
        if (mFormats != null) {
            for (Integer format : mFormats) {
                mScanner.setConfig(format, Config.ENABLE, 0);
            }
        }
        List<Integer> formats = Format.getFormats(rawFormats);
        for (Integer format : formats) {
            mScanner.setConfig(format, Config.ENABLE, 1);
        }
        mFormats = formats;
    }

    @Nullable
    public List<Result> decode(int[] pixels, int width, int height) {
        Image image = new Image(width, height, "RGB4");
        image.setData(pixels);
        image = image.convert("Y800");
        return decode(image);
    }

    @Nullable
    public List<Result> decode(byte[] data, int width, int height, Rect rect) {
        Image image = new Image(width, height, "Y800");
        image.setData(data);
        image.setCrop(rect.left, rect.top, rect.width(), rect.height());
        return decode(image);
    }

    @Nullable
    private List<Result> decode(Image image) {
        Integer decodeSign = mScanner.scanImage(image);
        image.destroy();
        if (!decodeSign.equals(0)) {
            SymbolSet decodeResults = mScanner.getResults();
            List<Result> results = new ArrayList<>();
            for (Symbol result : decodeResults) {
                String data = result.getData();
                // fix messy code
                Charset sjis = Charset.forName("Shift_JIS");
                Charset utf8 = Charset.forName("UTF-8");
                byte[] sijsData = data.getBytes(sjis);
                if (data.equals(new String(sijsData, sjis))) {
                    data = new String(sijsData, utf8);
                }
                results.add(new Result(result.getType(), data));
            }
            return results;
        } else return null;
    }

    public void release() {
        mScanner.destroy();
    }

    public enum Format {

        CODABAR(38, Symbol.CODABAR),

        CODE_39(39, Symbol.CODE39),

        CODE_93(93, Symbol.CODE93),

        CODE_128(128, Symbol.CODE128),

        EAN_8(8, Symbol.EAN8),

        EAN_13(13, Symbol.EAN13),

        PDF_417(57, Symbol.PDF417),

        QR_CODE(64, Symbol.QRCODE),

        UPC_A(12, Symbol.UPCA),

        UPC_E(9, Symbol.UPCE),

        DATABAR(34, Symbol.DATABAR),

        DATABAR_EXP(35, Symbol.DATABAR_EXP),

        I25(25, Symbol.I25),

        ISBN10(10, Symbol.ISBN10),

        ISBN13(14, Symbol.ISBN13);


        private int raw;
        private Integer format;

        Format(int raw, Integer format) {
            this.raw = raw;
            this.format = format;
        }

        public static Integer getFormat(int rawFormat) {
            for (Format format : Format.values()) {
                if (format.raw == rawFormat) {
                    return format.format;
                }
            }
            return null;
        }

        public static List<Integer> getFormats(int[] rawFormats) {
            List<Integer> formats = new ArrayList<>();
            for (int rawFormat : rawFormats) {
                Integer format = getFormat(rawFormat);
                if (format != null) {
                    formats.add(format);
                }
            }
            return formats;
        }
    }
}
