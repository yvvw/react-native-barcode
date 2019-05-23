import React from "react";
import {
    NativeSyntheticEvent,
    requireNativeComponent,
    StyleSheet,
    ViewProps,
} from "react-native";
import { Decoder, IDecodeResult, parseFormats } from "./decode";
import { BarCodeError } from "./error";

export enum TorchMode {
    Off = 0,
    On = 1,
    Auto = 2,
}

interface IScannerProps extends ViewProps {
    enable?: boolean;
    decoder?: Decoder;
    formats?: number | number[];
    torch?: TorchMode;
    onResult: (result: IDecodeResult | null, error: BarCodeError | null) => void;
}

const Scanner: React.ReactType =
    requireNativeComponent("RNLBarCodeScannerView");

interface IScanerError {
    code: number;
    message: string;
}

export default class extends React.Component<IScannerProps> {
    public render() {
        const { style } = this.props;
        return (
            <Scanner
                {...this.props}
                {...parseProps(this.props)}
                onResult={this.handleResult}
                onError={this.handleError}
                style={[styles.default, style]} />
        );
    }

    private handleResult = ({ nativeEvent: result }: NativeSyntheticEvent<IDecodeResult>) => {
        this.props.onResult(result, null);
    }

    private handleError = ({ nativeEvent: result }: NativeSyntheticEvent<IScanerError>) => {
        this.props.onResult(null, new BarCodeError(result.code, result.message));
    }
}

function parseProps(props: IScannerProps) {
    const {
        enable,
        decoder,
        formats,
        torch,
    } = props;

    return {
        enable: enable === undefined ? true : !!enable,
        decoderID: typeof decoder === "number" ? decoder : Decoder.Auto,
        formats: parseFormats(formats),
        torch: typeof torch === "number" ? torch : TorchMode.Off,
    };
}

const styles = StyleSheet.create({
    default: {
        overflow: "hidden",
        backgroundColor: "#000",
    },
});
