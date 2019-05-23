package com.rnlibrary.barcode;

public enum RNLBarCodeError {
    InvokeFailed(-1),
    NoCameraPermission(-2),
    NoCameraDevice(-3);

    private Integer code;

    RNLBarCodeError(Integer code) {
        this.code = code;
    }

    public Integer getCode() {
        return code;
    }

    @Override
    public String toString() {
        return String.valueOf(code);
    }
}
