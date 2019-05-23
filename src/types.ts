// BarCode Wiki
// 12   UPC_A           https://en.wikipedia.org/wiki/Universal_Product_Code
// 9    UPC_E           https://en.wikipedia.org/wiki/Universal_Product_Code#UPC-E
// 13   EAN_13          https://en.wikipedia.org/wiki/International_Article_Number
// 5    EAN_5           https://en.wikipedia.org/wiki/EAN-5
// 8    EAN_8           https://en.wikipedia.org/wiki/EAN-8
// 2    EAN_2           https://en.wikipedia.org/wiki/EAN-2
// 15   UPC_EAN
// 38   CODA_BAR        https://en.wikipedia.org/wiki/Codabar
// 39   CODE_39         https://en.wikipedia.org/wiki/Code_39
// 51   CODE_39_C
// 289  CODE_39_FA      https://en.wikipedia.org/wiki/Code_39#Full_ASCII_Code_39
// 4051 CODE_39_FA_C
// 106  CODE_39_MOD_43  https://en.wikipedia.org/wiki/Code_39#Code_39_mod_43
// 93   CODE_93         https://en.wikipedia.org/wiki/Code_93
// 931  CODE_93I        https://barcodeguide.seagullscientific.com/Content/Symbologies/Code_93i.htm
// 128  CODE_128        https://en.wikipedia.org/wiki/Code_128
// 25   ITF             https://en.wikipedia.org/wiki/Interleaved_2_of_5
// 37   ITF_C
// 45   ITF_14          https://en.wikipedia.org/wiki/ITF-14
// 34   DATA_BAR        https://en.wikipedia.org/wiki/GS1_DataBar
// 35   DATA_BAR_EXP
// --   ISBN      `     https://en.wikipedia.org/wiki/International_Standard_Book_Number
// 10   ISBN_10
// 14   ISBN_13
// 57   PDF417          https://en.wikipedia.org/wiki/PDF417
// 225  AZTEC           https://en.wikipedia.org/wiki/Aztec_Code
// 200  DATA_MATRIX     https://en.wikipedia.org/wiki/Data_Matrix
// 94   MAXI_CODE       https://en.wikipedia.org/wiki/MaxiCode
// 64   QR_CODE         https://en.wikipedia.org/wiki/QR_code

// ZXing BarCode Type
// https://github.com/zxing/zxing/blob/master/core/src/main/java/com/google/zxing/BarcodeFormat.java
export enum ZXing {
    // 1D
    UPC_A = 12,
    UPC_E = 9,
    EAN_13 = 13,
    EAN_8 = 8,
    CODA_BAR = 38,
    CODE_39 = 39,
    CODE_93 = 93,
    CODE_128 = 128,
    ITF = 25,
    DATA_BAR = 34,
    DATA_BAR_EXP = 35,
    PDF417 = 57,
    // 2D
    AZTEC = 225,
    DATA_MATRIX = 200,
    MAXI_CODE = 93,
    QR_CODE = 64,
}

// ZBar BarCode Type
// https://github.com/ZBar/ZBar/blob/master/include/zbar.h#L86
export enum ZBar {
    // 1D
    UPC_A = 12,
    UPC_E = 9,
    EAN_13 = 13,
    EAN_5 = 5,
    EAN_8 = 8,
    EAN_2 = 2,
    UPC_EAN = 15,
    CODA_BAR = 38,
    CODE_39 = 39,
    CODE_93 = 93,
    CODE_128 = 128,
    ITF = 25,
    DATA_BAR = 34,
    DATA_BAR_EXP = 35,
    ISBN_10 = 10,
    ISBN_13 = 14,
    // https://github.com/ZBar/ZBar/blob/master/iphone/include/config.h#L25
    // PDF417 = 57,
    // 2D
    QR_CODE = 64,
}

// iOS Vision Framework BarCode Type (iOS 11.0+)
// https://developer.apple.com/documentation/vision/vnbarcodesymbology
export enum Vision {
    // 1D
    UPC_E = 9,
    EAN_13 = 13,
    EAN_8 = 8,
    CODE_39 = 39,
    CODE_39_C = 39 + 0xC,
    CODE_39_FA = 39 + 0xFA,
    CODE_39_FA_C = 39 + 0xFAC,
    CODE_93 = 93,
    CODE_93I = 931,
    CODE_128 = 128,
    ITF = 25,
    ITF_C = 25 + 0xC,
    ITF_14 = 25 + 0x14,
    PDF417 = 57,
    // 2D
    AZTEC = 225,
    DATA_MATRIX = 200,
    QR_CODE = 64,
}

// iOS AVFoundation Framework BarCode Type (iOS 6.0+)
// https://developer.apple.com/documentation/avfoundation/avmetadataobjecttype
export enum AVFoundation {
    // 1D
    UPC_E = 9,
    EAN_13 = 13,
    EAN_8 = 8,
    CODE_39 = 39,
    CODE_39_MOD_43 = 39 + 0x43,
    CODE_93 = 93,
    CODE_128 = 128,
    ITF = 25,
    ITF_14 = 25 + 0x14,
    PDF417 = 57,
    // 2D
    AZTEC = 225,
    DATA_MATRIX = 200,
    QR_CODE = 64,
}

// All platform include
export enum Common {
    // 1D
    UPC_E = 9,
    EAN_13 = 13,
    EAN_8 = 8,
    CODE_39 = 39,
    CODE_93 = 93,
    CODE_128 = 128,
    ITF = 25,
    // 2D
    QR_CODE = 64,
}
