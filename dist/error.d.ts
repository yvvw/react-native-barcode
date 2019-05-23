export declare enum Errors {
    InvokeFailed = -1,
    NoCameraPermission = -2,
    NoCameraDevice = -3
}
export declare class BarCodeError extends Error {
    readonly code: number;
    readonly message: string;
    constructor(code: number, message: string);
}
