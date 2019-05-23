export declare enum Decoder {
    Auto = 0,
    ZXing = 1,
    ZBar = 2,
    Vision = 3,
    AVFoundation = 4
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
export declare function decode(option: IDecodeOption): Promise<IDecodeResult>;
export declare function parseFormats(formats: IDecodeOption["formats"]): number[];
export {};
