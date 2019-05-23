import React from "react";
import { requireNativeComponent, StyleSheet, } from "react-native";
import { Decoder, parseFormats } from "./decode";
import { BarCodeError } from "./error";
export var TorchMode;
(function (TorchMode) {
    TorchMode[TorchMode["Off"] = 0] = "Off";
    TorchMode[TorchMode["On"] = 1] = "On";
    TorchMode[TorchMode["Auto"] = 2] = "Auto";
})(TorchMode || (TorchMode = {}));
const Scanner = requireNativeComponent("RNLBarCodeScannerView");
export default class extends React.Component {
    constructor() {
        super(...arguments);
        this.handleResult = ({ nativeEvent: result }) => {
            this.props.onResult(result, null);
        };
        this.handleError = ({ nativeEvent: result }) => {
            this.props.onResult(null, new BarCodeError(result.code, result.message));
        };
    }
    render() {
        const { style } = this.props;
        return (<Scanner {...this.props} {...parseProps(this.props)} onResult={this.handleResult} onError={this.handleError} style={[styles.default, style]}/>);
    }
}
function parseProps(props) {
    const { enable, decoder, formats, torch, } = props;
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
