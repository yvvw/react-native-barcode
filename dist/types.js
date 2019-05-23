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
export var ZXing;
(function (ZXing) {
    // 1D
    ZXing[ZXing["UPC_A"] = 12] = "UPC_A";
    ZXing[ZXing["UPC_E"] = 9] = "UPC_E";
    ZXing[ZXing["EAN_13"] = 13] = "EAN_13";
    ZXing[ZXing["EAN_8"] = 8] = "EAN_8";
    ZXing[ZXing["CODA_BAR"] = 38] = "CODA_BAR";
    ZXing[ZXing["CODE_39"] = 39] = "CODE_39";
    ZXing[ZXing["CODE_93"] = 93] = "CODE_93";
    ZXing[ZXing["CODE_128"] = 128] = "CODE_128";
    ZXing[ZXing["ITF"] = 25] = "ITF";
    ZXing[ZXing["DATA_BAR"] = 34] = "DATA_BAR";
    ZXing[ZXing["DATA_BAR_EXP"] = 35] = "DATA_BAR_EXP";
    ZXing[ZXing["PDF417"] = 57] = "PDF417";
    // 2D
    ZXing[ZXing["AZTEC"] = 225] = "AZTEC";
    ZXing[ZXing["DATA_MATRIX"] = 200] = "DATA_MATRIX";
    ZXing[ZXing["MAXI_CODE"] = 93] = "MAXI_CODE";
    ZXing[ZXing["QR_CODE"] = 64] = "QR_CODE";
})(ZXing || (ZXing = {}));
// ZBar BarCode Type
// https://github.com/ZBar/ZBar/blob/master/include/zbar.h#L86
export var ZBar;
(function (ZBar) {
    // 1D
    ZBar[ZBar["UPC_A"] = 12] = "UPC_A";
    ZBar[ZBar["UPC_E"] = 9] = "UPC_E";
    ZBar[ZBar["EAN_13"] = 13] = "EAN_13";
    ZBar[ZBar["EAN_5"] = 5] = "EAN_5";
    ZBar[ZBar["EAN_8"] = 8] = "EAN_8";
    ZBar[ZBar["EAN_2"] = 2] = "EAN_2";
    ZBar[ZBar["UPC_EAN"] = 15] = "UPC_EAN";
    ZBar[ZBar["CODA_BAR"] = 38] = "CODA_BAR";
    ZBar[ZBar["CODE_39"] = 39] = "CODE_39";
    ZBar[ZBar["CODE_93"] = 93] = "CODE_93";
    ZBar[ZBar["CODE_128"] = 128] = "CODE_128";
    ZBar[ZBar["ITF"] = 25] = "ITF";
    ZBar[ZBar["DATA_BAR"] = 34] = "DATA_BAR";
    ZBar[ZBar["DATA_BAR_EXP"] = 35] = "DATA_BAR_EXP";
    ZBar[ZBar["ISBN_10"] = 10] = "ISBN_10";
    ZBar[ZBar["ISBN_13"] = 14] = "ISBN_13";
    // https://github.com/ZBar/ZBar/blob/master/iphone/include/config.h#L25
    // PDF417 = 57,
    // 2D
    ZBar[ZBar["QR_CODE"] = 64] = "QR_CODE";
})(ZBar || (ZBar = {}));
// iOS Vision Framework BarCode Type (iOS 11.0+)
// https://developer.apple.com/documentation/vision/vnbarcodesymbology
export var Vision;
(function (Vision) {
    // 1D
    Vision[Vision["UPC_E"] = 9] = "UPC_E";
    Vision[Vision["EAN_13"] = 13] = "EAN_13";
    Vision[Vision["EAN_8"] = 8] = "EAN_8";
    Vision[Vision["CODE_39"] = 39] = "CODE_39";
    Vision[Vision["CODE_39_C"] = 51] = "CODE_39_C";
    Vision[Vision["CODE_39_FA"] = 289] = "CODE_39_FA";
    Vision[Vision["CODE_39_FA_C"] = 4051] = "CODE_39_FA_C";
    Vision[Vision["CODE_93"] = 93] = "CODE_93";
    Vision[Vision["CODE_93I"] = 931] = "CODE_93I";
    Vision[Vision["CODE_128"] = 128] = "CODE_128";
    Vision[Vision["ITF"] = 25] = "ITF";
    Vision[Vision["ITF_C"] = 37] = "ITF_C";
    Vision[Vision["ITF_14"] = 45] = "ITF_14";
    Vision[Vision["PDF417"] = 57] = "PDF417";
    // 2D
    Vision[Vision["AZTEC"] = 225] = "AZTEC";
    Vision[Vision["DATA_MATRIX"] = 200] = "DATA_MATRIX";
    Vision[Vision["QR_CODE"] = 64] = "QR_CODE";
})(Vision || (Vision = {}));
// iOS AVFoundation Framework BarCode Type (iOS 6.0+)
// https://developer.apple.com/documentation/avfoundation/avmetadataobjecttype
export var AVFoundation;
(function (AVFoundation) {
    // 1D
    AVFoundation[AVFoundation["UPC_E"] = 9] = "UPC_E";
    AVFoundation[AVFoundation["EAN_13"] = 13] = "EAN_13";
    AVFoundation[AVFoundation["EAN_8"] = 8] = "EAN_8";
    AVFoundation[AVFoundation["CODE_39"] = 39] = "CODE_39";
    AVFoundation[AVFoundation["CODE_39_MOD_43"] = 106] = "CODE_39_MOD_43";
    AVFoundation[AVFoundation["CODE_93"] = 93] = "CODE_93";
    AVFoundation[AVFoundation["CODE_128"] = 128] = "CODE_128";
    AVFoundation[AVFoundation["ITF"] = 25] = "ITF";
    AVFoundation[AVFoundation["ITF_14"] = 45] = "ITF_14";
    AVFoundation[AVFoundation["PDF417"] = 57] = "PDF417";
    // 2D
    AVFoundation[AVFoundation["AZTEC"] = 225] = "AZTEC";
    AVFoundation[AVFoundation["DATA_MATRIX"] = 200] = "DATA_MATRIX";
    AVFoundation[AVFoundation["QR_CODE"] = 64] = "QR_CODE";
})(AVFoundation || (AVFoundation = {}));
// All platform include
export var Common;
(function (Common) {
    // 1D
    Common[Common["UPC_E"] = 9] = "UPC_E";
    Common[Common["EAN_13"] = 13] = "EAN_13";
    Common[Common["EAN_8"] = 8] = "EAN_8";
    Common[Common["CODE_39"] = 39] = "CODE_39";
    Common[Common["CODE_93"] = 93] = "CODE_93";
    Common[Common["CODE_128"] = 128] = "CODE_128";
    Common[Common["ITF"] = 25] = "ITF";
    // 2D
    Common[Common["QR_CODE"] = 64] = "QR_CODE";
})(Common || (Common = {}));
