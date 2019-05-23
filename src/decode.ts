import { Image, NativeModules } from "react-native";
import { BarCodeError, Errors } from "./error";

const RNLBModule = NativeModules.RNLBarCode;

export enum Decoder {
    Auto = 0,
    ZXing = 1,
    ZBar = 2,
    Vision = 3,
    AVFoundation = 4,
}

interface IDecodeOption {
    data: string | number;
    screenshot?: boolean;
    formats?: number | number[];
    decoder?: Decoder;
}

export interface IDecodeResult {
    format: number;
    content: string;
}

export function decode(option: IDecodeOption): Promise<IDecodeResult> {
    try {
        return RNLBModule.decode(parseOption(option));
    } catch (e) {
        throw new BarCodeError(parseInt(e.code, 10), e.message);
    }
}

const defaultOption: IDecodeOption = {
    data: "",
    screenshot: false,
    formats: [],
    decoder: Decoder.Auto,
};

function parseOption(o: any): IDecodeOption {
    const option = Object.assign({}, defaultOption);

    if (o.screenshot) {
        option.screenshot = o.screenshot;
    } else {
        if (typeof o.data === "number") {
            const r = Image.resolveAssetSource(o.data);
            // @ts-ignore
            if (r && r.__packager_asset) {
                option.data =  r.uri;
            } else {
                throw new BarCodeError(Errors.InvokeFailed,
                    "Resolve image asset failed.");
            }
        } else {
            if (typeof o.data === "string") {
                option.data = o.data;
            } else {
                throw new BarCodeError(Errors.InvokeFailed,
                    `Expected data is string, but get ${o.data}.`);
            }
        }
    }

    if (typeof o.decoder === "number") {
        option.decoder = o.decoder;
    }

    option.formats = parseFormats(o.formats);

    return option;
}

export function parseFormats(formats: IDecodeOption["formats"]) {
    if (typeof formats === "number") {
        return [formats];
    } else if (Array.isArray(formats)) {
        return formats;
    }
    return [];
}
