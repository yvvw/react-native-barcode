package com.react.barcode;

public enum Error {
    BARCODE_NOT_FOUND(-1),
    DECODE_FAILED(-2),
    FILE_NOT_FOUND(-3),
    NOT_GRANT_READ_IMAGE(-4),
    NOT_GRANT_USE_CAMERA(-5),
    DEVICE_NO_CAMERA(-6),
    OPEN_CAMERA_FAILED(-7);

    private int code;

    Error(int code) {
        this.code = code;
    }

    public String getCode() {
        return String.valueOf(this.code);
    }
}
