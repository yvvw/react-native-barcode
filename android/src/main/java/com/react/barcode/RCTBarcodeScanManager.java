package com.react.barcode;

import android.support.annotation.Nullable;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.PixelUtil;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.google.android.cameraview.Size;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class RCTBarcodeScanManager extends SimpleViewManager<RCTBarcodeScanView> {
    private static final String REACT_CLASS = "RCTBarcodeScanView";

    private final List<String> eventNames = Arrays.asList("onScan", "onError");

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected RCTBarcodeScanView createViewInstance(ThemedReactContext reactContext) {
        return new RCTBarcodeScanView(reactContext);
    }

    @Override
    @Nullable
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        MapBuilder.Builder<String, Object> builder = MapBuilder.builder();
        for (String eventName : eventNames) {
            builder.put(eventName, MapBuilder.of("registrationName", eventName));
        }
        return builder.build();
    }

    @ReactProp(name = "enable")
    public void setEnable(RCTBarcodeScanView view, boolean enable) {
        view.setEnable(enable);
    }

    @ReactProp(name = "flash")
    public void setFlash(RCTBarcodeScanView view, boolean flash) {
        view.setFlash(flash);
    }

    @ReactProp(name = "autoFocus")
    public void setAutoFocus(RCTBarcodeScanView view, boolean autoFocus) {
        view.setAutoFocus(autoFocus);
    }

    @ReactProp(name = "formats")
    public void setBarcodeFormat(RCTBarcodeScanView view, ReadableArray formats) {
        int[] rawFormats = new int[formats.size()];
        for (int i = 0; i < formats.size(); i++) {
            rawFormats[i] = formats.getInt(i);
        }
        view.setFormats(rawFormats);
    }

    @ReactProp(name = "scanSize")
    public void setScanSize(RCTBarcodeScanView view, ReadableMap scanSize) {
        int width = (int) PixelUtil.toPixelFromDIP(scanSize.getDouble("width"));
        int height = (int) PixelUtil.toPixelFromDIP(scanSize.getDouble("height"));
        view.setScanSize(new Size(width, height));
    }
}
