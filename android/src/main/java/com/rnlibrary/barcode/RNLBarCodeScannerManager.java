package com.rnlibrary.barcode;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

import javax.annotation.Nullable;

public class RNLBarCodeScannerManager extends SimpleViewManager<RNLBarCodeScannerView> {
    private static final String ViewName = "RNLBarCodeScannerView";

    @ReactProp(name = "enable")
    public void setEnable(RNLBarCodeScannerView view, boolean enable) {
        view.setEnable(enable);
    }

    @ReactProp(name = "decoderID")
    public void setDecoder(RNLBarCodeScannerView view, int decoderID) {
        view.setDecoder(decoderID);
    }

    @ReactProp(name = "formats")
    public void setFormats(RNLBarCodeScannerView view, ReadableArray formats) {
        view.setFormats(formats);
    }

    @ReactProp(name = "torch")
    public void setTorch(RNLBarCodeScannerView view, int torch) {
        view.setTorch(torch);
    }

    @Override
    public String getName() {
        return ViewName;
    }

    @Override
    public RNLBarCodeScannerView createViewInstance(ThemedReactContext reactContext) {
        return new RNLBarCodeScannerView(reactContext);
    }

    @Override
    public void onDropViewInstance(RNLBarCodeScannerView view) {
        super.onDropViewInstance(view);
        view.release();
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        return MapBuilder.<String, Object>builder()
                .put("onResult", MapBuilder.of("registrationName", "onResult"))
                .put("onError", MapBuilder.of("registrationName", "onError"))
                .build();
    }
}
