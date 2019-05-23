import React from "react";
import { ViewProps } from "react-native";
import { Decoder, IDecodeResult } from "./decode";
import { BarCodeError } from "./error";
export declare enum TorchMode {
    Off = 0,
    On = 1,
    Auto = 2
}
interface IScannerProps extends ViewProps {
    enable?: boolean;
    decoder?: Decoder;
    formats?: number | number[];
    torch?: TorchMode;
    onResult: (result: IDecodeResult | null, error: BarCodeError | null) => void;
}
export default class extends React.Component<IScannerProps> {
    render(): JSX.Element;
    private handleResult;
    private handleError;
}
export {};
