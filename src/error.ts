export enum Errors {
    InvokeFailed = -1,
    NoCameraPermission = -2,
    NoCameraDevice = -3,
}

export class BarCodeError extends Error {
    constructor(readonly code: number, readonly message: string) {
        super(message);
        // @ts-ignore
        if (Error.captureStackTrace) {
            // @ts-ignore
            Error.captureStackTrace(this, BarCodeError);
        }
        this.name = "BarCodeError";
    }
}
