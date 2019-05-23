export var Errors;
(function (Errors) {
    Errors[Errors["InvokeFailed"] = -1] = "InvokeFailed";
    Errors[Errors["NoCameraPermission"] = -2] = "NoCameraPermission";
    Errors[Errors["NoCameraDevice"] = -3] = "NoCameraDevice";
})(Errors || (Errors = {}));
export class BarCodeError extends Error {
    constructor(code, message) {
        super(message);
        this.code = code;
        this.message = message;
        // @ts-ignore
        if (Error.captureStackTrace) {
            // @ts-ignore
            Error.captureStackTrace(this, BarCodeError);
        }
        this.name = "BarCodeError";
    }
}
