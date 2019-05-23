import { Image, NativeModules } from "react-native";
import { BarCodeError, Errors } from "./error";
const RNLBModule = NativeModules.RNLBarCode;
export var Decoder;
(function (Decoder) {
    Decoder[Decoder["Auto"] = 0] = "Auto";
    Decoder[Decoder["ZXing"] = 1] = "ZXing";
    Decoder[Decoder["ZBar"] = 2] = "ZBar";
    Decoder[Decoder["Vision"] = 3] = "Vision";
    Decoder[Decoder["AVFoundation"] = 4] = "AVFoundation";
})(Decoder || (Decoder = {}));
export function decode(option) {
    try {
        return RNLBModule.decode(parseOption(option));
    }
    catch (e) {
        throw new BarCodeError(parseInt(e.code, 10), e.message);
    }
}
const defaultOption = {
    data: "",
    screenshot: false,
    formats: [],
    decoder: Decoder.Auto,
};
function parseOption(o) {
    const option = Object.assign({}, defaultOption);
    if (o.screenshot) {
        option.screenshot = o.screenshot;
    }
    else {
        if (typeof o.data === "number") {
            const r = Image.resolveAssetSource(o.data);
            // @ts-ignore
            if (r && r.__packager_asset) {
                option.data = r.uri;
            }
            else {
                throw new BarCodeError(Errors.InvokeFailed, "Resolve image asset failed.");
            }
        }
        else {
            if (typeof o.data === "string") {
                option.data = o.data;
            }
            else {
                throw new BarCodeError(Errors.InvokeFailed, `Expected data is string, but get ${o.data}.`);
            }
        }
    }
    if (typeof o.decoder === "number") {
        option.decoder = o.decoder;
    }
    option.formats = parseFormats(o.formats);
    return option;
}
export function parseFormats(formats) {
    if (typeof formats === "number") {
        return [formats];
    }
    else if (Array.isArray(formats)) {
        return formats;
    }
    return [];
}
